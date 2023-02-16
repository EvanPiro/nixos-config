{
  inputs = {
    nixos-hardware.url = "github:nixos/nixos-hardware";
    nixpkgs.url = "github:EvanPiro/nixpkgs/postgrest";
    mypkgs.url = "github:EvanPiro/mypkgs";
    home-manager.url = github:nix-community/home-manager/release-22.11;
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = {
    self,
    nixpkgs,
    home-manager,
    nixos-hardware,
    mypkgs,
  } @ inputs: let
    system = "x86_64-linux";
  in {
    formatter.${system} = nixpkgs.legacyPackages.${system}.alejandra;
    nixosConfigurations.tower = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        {
          _module.args = {
            inherit inputs;
            mypkgs = mypkgs.packages.${system};
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
  };
}
