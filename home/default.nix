{ 
	config, 
	pkgs, 
	lib,
	...
}: {

	home = {
		enableNixpkgsReleaseCheck = false;
		#  packages = pkgs.callPackage ./packages.nix {};
		packages = with pkgs; [
			sl
		];
		stateVersion = "23.11";
	};

	programs = {
		home-manager.enable = true;
	} // import ./programs { inherit config pkgs lib; };

	# Marked broken Oct 20, 2022 check later to remove this
	# https://github.com/nix-community/home-manager/issues/3344
	# manual.manpages.enable = false;	
}
