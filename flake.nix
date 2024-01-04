{
  description = "Example Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager }: {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#Aoifes-MacBook-Air
    darwinConfigurations."Aoifes-MacBook-Air" = nix-darwin.lib.darwinSystem {
      specialArgs = inputs;
      modules = [ 
        ./hosts/darwin
        home-manager.darwinModules.home-manager
      ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."Aoifes-MacBook-Air".pkgs;
  };
}
