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

  outputs = inputs@{ self, nixpkgs, home-manager, deploy-rs, sops-nix }: {
    inputs.deploy-rs.inputs.nixpkgs.follows = "nixpkgs";
    nixosConfigurations.gipsy-avenger = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules =
        [ ./hosts/avenger/configuration.nix sops-nix.nixosModules.sops ];
    };
    homeConfigurations = {
      "nullrequest@gipsy-avenger" = home-manager.lib.homeManagerConfiguration {
         extraSpecialArgs = { inherit inputs; };
        system = "x86_64-linux";
        username = "nullrequest";
        homeDirectory = "/home/nullrequest";
        stateVersion = "22.05";

        configuration.imports = [
          ./home/nullrequest-gipsy-avenger/home.nix
        ];
      };
      "nullrequest@archwinux" = home-manager.lib.homeManagerConfiguration {
        extraSpecialArgs = { inherit inputs; };
        system = "x86_64-linux";
        username = "nullrequest";
        homeDirectory = "/home/nullrequest";
        stateVersion = "22.05";

        configuration.imports = [ ./home/nullrequest-archbook/home.nix ];
      };
    };
  };
}
