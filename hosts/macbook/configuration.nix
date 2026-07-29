{ self, config, pkgs, lib, hostUsers, primaryUser, ...}: {

  users.users = lib.genAttrs hostUsers (name: {
    name = name;
    home = "/Users/${name}";
    isHidden = false;
  });

  system.primaryUser = primaryUser;

  nix = {
    package = pkgs.nixVersions.git;
    settings.trusted-users = [ "@admin" ] ++ hostUsers;
    settings.experimental-features = "nix-command flakes";
    gc = {
      automatic = true;
      interval = { Weekday = 0; Hour = 2; Minute = 0; };
      options = "--delete-older-than 30d";
    };
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [ orbstack vim rustup cargo-mommy wget ];

  system = {
    configurationRevision = self.rev or self.dirtyRev or null;
    stateVersion = 5;
    defaults.dock.autohide = true;
  };

}
