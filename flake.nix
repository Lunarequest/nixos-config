{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    deploy-rs.url = "github:serokell/deploy-rs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = inputs@{ self, nixpkgs, home-manager, deploy-rs }: {
    inputs.deploy-rs.inputs.nixpkgs.follows = "nixpkgs";
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

        configuration.imports = [ ./home/nullrequest-gipsy-avenger/home.nix ];
      };
      "nullrequest" = home-manager.lib.homeManagerConfiguration {
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
