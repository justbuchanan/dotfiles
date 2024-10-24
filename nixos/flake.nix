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
    cadquery = {
      url = "github:marcus7070/cq-flake";
    };
  };

  outputs = { self, nixpkgs, mediaplayer, cadquery }@inputs: {
    nixosConfigurations = {
      framework = nixpkgs.lib.nixosSystem {
        specialArgs.inputs = inputs;
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
        ];
      };
    };
  };
}
