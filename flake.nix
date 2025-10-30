{
  description = "Ash’s NixOS configuration for Apple Silicon with Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      system = "aarch64-linux";              # для M1/M2
      pkgs = import nixpkgs { inherit system; };
    in {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
          inherit system;

          modules = [
            ./configuration.nix
            ./apple-silicon-support
            home-manager.nixosModules.default

            {
	      home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "backup";
                users.ash = import ./home.nix;
	      };
            }
          ];
        };
    };
}
