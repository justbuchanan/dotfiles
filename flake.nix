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
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    hy3 = {
      url = "github:outfoxxed/hy3";
      inputs.hyprland.follows = "hyprland";
    };
    niri = {
      url = "github:sodiboo/niri-flake";
    };
    niri-autoname-workspaces = {
      url = "github:justbuchanan/niri-autoname-workspaces";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # cadquery = {
    #   url = "github:marcus7070/cq-flake";
    #   # rev = "de4b29ee5cf2fdd2a8ba97010442511e162b6041";
    # };
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
  };

  outputs =
    {
      self,
      nixpkgs,
      determinate,
      disko,
      agenix,
      mediaplayer,
      # cadquery,
      hyprland,
      hy3,
      niri,
      niri-autoname-workspaces,
      hyprland-plugins,
      home-manager,
      stylix,
      nixvim,
      nixos-hardware,
    }@inputs:
    {
      nixosConfigurations = {
        framework = nixpkgs.lib.nixosSystem {
          specialArgs.inputs = inputs;
          system = "x86_64-linux";
          modules = [
            ./hosts/framework/configuration.nix
            determinate.nixosModules.default
            # https://github.com/NixOS/nixos-hardware/tree/master/framework/13-inch/13th-gen-intel
            nixos-hardware.nixosModules.framework-13th-gen-intel
          ];
        };

        # DigitalOcean Droplet
        droplet1 = nixpkgs.lib.nixosSystem {
          specialArgs.inputs = inputs;
          system = "x86_64-linux";
          modules = [
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
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.sharedModules = [
                nixvim.homeModules.nixvim
                stylix.homeModules.stylix
              ];
            }
          ];
        };
      };

      homeConfigurations = {
        # Framework laptop - NixOS
        "justin@framework" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;

          extraSpecialArgs = { inherit inputs; };

          modules = [
            ./home.nix
            nixvim.homeModules.nixvim
            niri.homeModules.niri
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
          pkgs = nixpkgs.legacyPackages.x86_64-linux;

          extraSpecialArgs = { inherit inputs; };

          modules = [
            ./home.nix
            nixvim.homeModules.nixvim
            niri.homeModules.niri
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
