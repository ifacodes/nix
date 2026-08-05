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
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [ nh orbstack vim rustup cargo-mommy wget ];
  environment.variables.NH_FLAKE = "/Users/${primaryUser}/.config/nixos";

  # nix-darwin has no programs.nh module, so the periodic `nh clean` that
  # programs.nh.clean.enable would give us on NixOS is hand-rolled here.
  # Same schedule the old nix.gc had: Sundays at 02:00.
  launchd.daemons.nh-clean = {
    serviceConfig = {
      ProgramArguments = [
        (lib.getExe pkgs.nh)
        "clean"
        "all"
        "--keep"
        "5"
        "--keep-since"
        "7d"
      ];
      StartCalendarInterval = [ { Weekday = 0; Hour = 2; Minute = 0; } ];
      EnvironmentVariables.PATH = "${config.nix.package}/bin:/usr/bin:/bin:/usr/sbin:/sbin";
      RunAtLoad = false;
    };
  };

  system = {
    configurationRevision = self.rev or self.dirtyRev or null;
    stateVersion = 5;
    defaults.dock.autohide = true;
  };

}
