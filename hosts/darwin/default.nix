{ 
  self,
  config, 
  pkgs, 
  overlays,
  ... 
}: let
  user = "ifa";
in {
 # imports = [ ../../home ];

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

	users.users.${user} = {
		name = "${user}";
		home = "/Users/${user}";
		isHidden = false;
		#shell = pkgs.zsh;
	};
  
  nix = {
    package = pkgs.nixUnstable;
    settings.trusted-users = [ 
        "@admin" 
        "${user}"
      ];
    settings.experimental-features = "nix-command flakes";
      
    gc = {
      user = "root";
      automatic = true;
      interval = { Weekday = 0; Hour = 2; Minute = 0; };
      options = "--delete-older-than 30d";  
    };
  };

  # The platform the configuration will be used on.
  nixpkgs = {
    hostPlatform = "aarch64-darwin";
    overlays = [
      overlays.modifications
    ];
  };
  
  environment.systemPackages = with pkgs; [
    vim
    # (rust-bin.stable.latest.default.override {
    #   extensions = [ "rust-src" ];
    # })
    cargo-mommy
    wget
  ];

  fonts.fontDir.enable = true;

  system = {
    # Set Git commit has for darwin-version.
    configurationRevision = self.rev or self.dirtyRev or null;
    
    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    stateVersion = 4;

    defaults = {
      dock = {
        autohide = true;
      };
    };
    
  };
  
}
