{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { self, nixpkgs, home-manager }:
    {
       nixosConfigurations.gipsy-avenger = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [ ./hosts/avenger/configuration.nix ];
        };
        homeConfigurations = {
            "nullrequest@gipsy-avenger" = home-manager.lib.homeManagerConfiguration {
                system = "x86_64-linux";
                username = "nullrequest";
                homeDirectory = "/home/nullrequest";
                stateVersion = "22.05";

                configuration.imports = [
                    ./home/nullrequest/home.nix
                ];
            }; 
        };
    };
}
