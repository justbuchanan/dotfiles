{
  description = "Home Manager configuration for dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
    };

    ghostty = {
      url = "github:ghostty-org/ghostty";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      niri,
      ghostty,
      ...
    }@inputs:
    {
      homeConfigurations = {
        # Desktop computer - Arch Linux
        "justin@srvbox" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;

          extraSpecialArgs = { inherit inputs; };

          modules = [
            ./home-manager/home.nix
            niri.homeModules.niri
            {
              home = {
                username = "justin";
                homeDirectory = "/home/justin";
                stateVersion = "24.05";
              };
            }
          ];
        };

        # Laptop - NixOS
        "justin@framework" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;

          extraSpecialArgs = { inherit inputs; };

          modules = [
            ./home-manager/home.nix
            niri.homeModules.niri
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
    };
}
