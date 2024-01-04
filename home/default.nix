{ 
	config, 
	pkgs, 
	lib, 
	home-manager, 
	...
}: let
		name = "Aoife Bradley";
		user = "ifa";
		email = "me@ifa.codes";
in {
	users.users.${user} = {
		name = ${user};
		home = "/Users/${user}";
		isHidden = false;
		shell = pkgs.zsh;
	};

	homebrew = {
		enable = true;
		# casks = pkgs.callPackage ./casks.nix {};
	};

	home-manager = {
		useGlobalPkgs = true;
		useUserPackages = true;
		user.$(user) = { pkgs, config, lib, ...}: {
			home = {
				enableNixpkgsReleaseCheck = false;
				#  packages = pkgs.callPackage ./packages.nix {};
				stateVersion = "23.11";
			};

			programs = {
				import ./programs { inherit config pkgs libs name user email; };
			};

			# Marked broken Oct 20, 2022 check later to remove this
			# https://github.com/nix-community/home-manager/issues/3344
			# manual.manpages.enable = false;
			
		};
	};
	
}
