{
  description = "flake setup for nixtop";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    mediaplayer = {
      url = "github:nomisreual/mediaplayer";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # cadquery = {
    #   url = "github:marcus7070/cq-flake";
    #   # rev = "de4b29ee5cf2fdd2a8ba97010442511e162b6041";
    # };
    ghostty = {
      url = "github:ghostty-org/ghostty";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware";
  };

  outputs =
    {
      self,
      nixpkgs,
      mediaplayer,
      # cadquery,
      ghostty,
      home-manager,
      nixos-hardware,
    }@inputs:
    {
      nixosConfigurations = {
        framework = nixpkgs.lib.nixosSystem {
          specialArgs.inputs = inputs;
          system = "x86_64-linux";
          modules = [
            ./configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.justin = import ./home.nix;
            }
            {
              environment.systemPackages = [
                ghostty.packages.x86_64-linux.default
              ];
            }

            # https://github.com/NixOS/nixos-hardware/tree/master/framework/13-inch/13th-gen-intel
            nixos-hardware.nixosModules.framework-13th-gen-intel
          ];
        };
      };
    };
}
