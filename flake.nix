{
  description = "Ash’s NixOS configuration for Apple Silicon with Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    elephant.url = "github:abenz1267/elephant";
    walker = {
      url = "github:abenz1267/walker";
      inputs.elephant.follows = "elephant";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, elephant, walker, ... }:
    let
      system = "aarch64-linux";              # для M1/M2
      pkgs = import nixpkgs { inherit system; };
    in {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
          inherit system;

          modules = [
            { environment.systemPackages = [ inputs.elephant.packages.${system}.default ]; }
            
            ./configuration.nix
            ./apple-silicon-support
            home-manager.nixosModules.default

            {
	      home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "backup";
                users.ash = {
                  imports= [
                    inputs.walker.homeManagerModules.default
                    ./home.nix
                  ];
                };
	      };
            }
          ];
        };
    };
}
