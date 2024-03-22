{ 
	config, 
	pkgs, 
	lib,
	overlays,
	...
}: {

	imports = [
		./programs
	];

	home = {
		enableNixpkgsReleaseCheck = false;
		#  packages = pkgs.callPackage ./packages.nix {};
		packages = with pkgs; [
			sl
			lilypond-with-fonts
			mysql
		];
		stateVersion = "23.11";
	};

	programs = {
		home-manager.enable = true;
	};

	nixpkgs = {
		overlays = [
			overlays.modifications
		];
	};
	
	# Marked broken Oct 20, 2022 check later to remove this
	# https://github.com/nix-community/home-manager/issues/3344
	# manual.manpages.enable = false;	
}
