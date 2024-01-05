{
  description = "Example Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager, ... }: {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#Aoifes-MacBook-Air
    darwinConfigurations."Aoifes-MacBook-Air" = nix-darwin.lib.darwinSystem {
      specialArgs = inputs;
      modules = [ 
        home-manager.darwinModules.home-manager 
        {
        	homebrew = {
        		enable = true;
        		# casks = pkgs.callPackage ./casks.nix {};
        	};
          home-manager.useGlobalPkgs = true;
          # home-manager.useUserPkgs= true;
          home-manager.users.ifa = import ./home;
        }
        ./hosts/darwin
      ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."Aoifes-MacBook-Air".pkgs;
  };
}
