{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    deploy-rs.url = "github:serokell/deploy-rs";
    sops-nix.url = "github:Mic92/sops-nix";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = inputs@{ self, nixpkgs, home-manager, deploy-rs, sops-nix }:
    let pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in {
      inputs.deploy-rs.inputs.nixpkgs.follows = "nixpkgs";
      nixosConfigurations.gipsy-avenger = nixpkgs.lib.nixosSystem {
        modules =
          [ ./hosts/avenger/configuration.nix sops-nix.nixosModules.sops ];
      };
      homeConfigurations = {
        "nullrequest@gipsy-avenger" =
          home-manager.lib.homeManagerConfiguration {
            extraSpecialArgs = { inherit inputs; };
            pkgs = pkgs;

            modules = [
              ./home/nullrequest-gipsy-avenger/home.nix
              {
                home = {      
                  username = "nullrequest";
                  homeDirectory = "/home/nullrequest";
                  stateVersion = "22.05";
                };
              }
            ];
          };
        "nullrequest@lifrith" = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgs;
          extraSpecialArgs = { inherit inputs; };
          modules = [
            ./home/nullrequest-lifrith/home.nix
            +
            {
              home = {
                username = "nullrequest";
                homeDirectory = "/home/nullrequest";
                stateVersion = "22.05";
              };
            }
          ];
        };
        "luna@aerial" = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgs;
          extraSpecialArgs = { inherit inputs; };
          modules = [
            ./home/luna-aerial/home.nix
            {
              home = {
                username = "luna";
                homeDirectory = "/home/luna";
                stateVersion = "22.05";
              };
            }
          ];
        };
      };
    };
}
