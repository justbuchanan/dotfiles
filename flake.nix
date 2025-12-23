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
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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

    darktable-nixpkgs = {
      url = "github:justbuchanan/nixpkgs/darktable-5.4";
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
      darktable-nixpkgs,
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
          ];
        };

        # DigitalOcean Droplet
        droplet1 = nixpkgs.lib.nixosSystem {
          specialArgs.inputs = inputs;
          system = "x86_64-linux";
          modules = [
            ./nixos/cachix.nix
            ./hosts/droplet1/digitalocean.nix
            disko.nixosModules.disko
            { disko.devices.disk.disk1.device = "/dev/vda"; }
            determinate.nixosModules.default
            agenix.nixosModules.default
            ./hosts/droplet1/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useUserPackages = true;
              home-manager.users.justin = import ./hosts/droplet1/justin.nix;
              home-manager.users.root = import ./hosts/droplet1/justin.nix;
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.sharedModules = [
                nixvim.homeModules.nixvim
                stylix.homeModules.stylix
              ];
            }
          ];
        };
      };

      homeConfigurations =
        let
          darktableOverlay = final: prev: {
            darktable = darktable-nixpkgs.legacyPackages.${final.system}.darktable;
          };
          pkgsWithOverlays = import nixpkgs {
            system = "x86_64-linux";
            overlays = [ darktableOverlay ];
          };
        in
        {
          # Framework laptop - NixOS
          justin = home-manager.lib.homeManagerConfiguration {
            pkgs = pkgsWithOverlays;

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

          # Desktop computer - Arch Linux
          "justin@srvbox" = home-manager.lib.homeManagerConfiguration {
            pkgs = pkgsWithOverlays;

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
        };

      # devshell provides code formatting tools
      devShells.x86_64-linux.default =
        let
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
        in
        pkgs.mkShell {
          packages = with pkgs; [
            nixfmt-rfc-style
            nixos-rebuild
            nodePackages.prettier
            shellcheck
            shfmt
            treefmt
          ];
        };
    };
}
