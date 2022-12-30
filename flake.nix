{
  inputs = {
    nixos-hardware.url = "github:nixos/nixos-hardware";
    nixpkgs.url = "github:EvanPiro/nixpkgs";
    home-manager.url = github:nix-community/home-manager/release-22.11;
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = {
    self,
    nixpkgs,
    home-manager,
    nixos-hardware,
    flake-utils,
  } @ inputs:
    flake-utils.lib.eachDefaultSystem (system: {
      formatter = nixpkgs.legacyPackages.${system}.alejandra;
      nixosConfigurations.tower = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          {
            _module.args = {
              inherit inputs;
            };
          }
          ./configuration.nix
          nixos-hardware.nixosModules.common-cpu-amd
          nixos-hardware.nixosModules.common-gpu-amd
          home-manager.nixosModules.home-manager
          ({...}: {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.evan = {
              imports = [
                ./users/evan/home.nix
              ];
            };
          })
        ];
      };
    });
}
