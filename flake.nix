{
  description = "flake setup for nixtop";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    determinate = {
      url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mediaplayer = {
      url = "github:nomisreual/mediaplayer";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri = {
      url = "github:sodiboo/niri-flake";
    };
    waybar-niri-workspaces-enhanced.url = "github:justbuchanan/waybar-niri-workspaces-enhanced";

    cadquery.url = "github:vinszent/cq-flake?rev=e0c9db750f3ff0f25ba327a8e847a2f0d61fb063";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim.url = "github:nix-community/nixvim";

    nixos-hardware.url = "github:NixOS/nixos-hardware";

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    oasis = {
      url = "github:justbuchanan/oasis";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      determinate,
      disko,
      agenix,
      mediaplayer,
      cadquery,
      niri,
      waybar-niri-workspaces-enhanced,
      home-manager,
      stylix,
      nixvim,
      nixos-hardware,
      oasis,
    }@inputs:
    {
      nixosConfigurations = {
        # framework 13 laptop
        framework = nixpkgs.lib.nixosSystem {
          specialArgs.inputs = inputs;
          system = "x86_64-linux";
          modules = [
            ./nixos/cachix.nix
            ./hosts/framework/configuration.nix
            determinate.nixosModules.default
            agenix.nixosModules.default
            # https://github.com/NixOS/nixos-hardware/tree/master/framework/13-inch/13th-gen-intel
            nixos-hardware.nixosModules.framework-13th-gen-intel
            inputs.niri.nixosModules.niri
            # niri-flake HEAD (2026-08-04) asserts libdisplay-info 0.2.0, which
            # nixpkgs has since removed -- and its extraPortals mkIf *condition*
            # reads cfg.package, so the default is forced even when unused. Use
            # the flake's own package, built against its pinned nixpkgs, until
            # upstream catches up.
            { programs.niri.package = inputs.niri.packages.x86_64-linux.niri-unstable; }
          ];
        };

        # srvbox - desktop computer / home server
        srvbox = nixpkgs.lib.nixosSystem {
          specialArgs.inputs = inputs;
          system = "x86_64-linux";
          modules = [
            ./nixos/cachix.nix
            disko.nixosModules.disko
            { disko.devices.disk.disk1.device = "/dev/nvme0n1"; }
            ./hosts/srvbox/configuration.nix
            determinate.nixosModules.default
            agenix.nixosModules.default
            inputs.niri.nixosModules.niri
            { programs.niri.package = inputs.niri.packages.x86_64-linux.niri-unstable; }
          ];
        };

        # DigitalOcean Droplet
        droplet2 = nixpkgs.lib.nixosSystem {
          specialArgs.inputs = inputs;
          system = "x86_64-linux";
          modules = [
            ./nixos/cachix.nix
            ./hosts/droplet2/digitalocean.nix
            disko.nixosModules.disko
            { disko.devices.disk.disk1.device = "/dev/vda"; }
            determinate.nixosModules.default
            agenix.nixosModules.default
            ./hosts/droplet2/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useUserPackages = true;
              home-manager.users.justin = import ./hosts/droplet2/justin.nix;
              home-manager.users.root = import ./hosts/droplet2/justin.nix;
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.sharedModules = [
                nixvim.homeModules.nixvim
                stylix.homeModules.stylix
              ];
            }
          ];
        };
      };

      # Standalone home-manager config, shared by the framework laptop and srvbox
      homeConfigurations = rec {
        justin = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;

          extraSpecialArgs = { inherit inputs; };

          modules = [
            ./home.nix
            nixvim.homeModules.nixvim
            niri.homeModules.niri
            waybar-niri-workspaces-enhanced.homeModules.default
            stylix.homeModules.stylix
            {
              home = {
                username = "justin";
                homeDirectory = "/home/justin";
                stateVersion = "24.05";
              };
            }
          ];
        };

        "justin@srvbox" = justin;
      };

      # devshell provides code formatting tools
      devShells.x86_64-linux.default =
        let
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
        in
        pkgs.mkShell {
          packages = with pkgs; [
            nixfmt
            nixos-rebuild
            prettier
            shellcheck
            shfmt
            treefmt
          ];
        };
    };
}
