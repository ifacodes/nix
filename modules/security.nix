{ ... }:

{
  security.pam.services.hyprlock = { };
  security.pam.services.meowshell.text = ''
    account required pam_unix.so
    auth sufficient pam_unix.so nodelay likeauth nullok try_first_pass
    auth required pam_deny.so
    password sufficient pam_unix.so nullok yescrypt
  '';

  security.sudo.extraRules = [{
    users = [ "ifa" ];
    commands = [{
      command = "/run/current-system/sw/bin/nixos-rebuild";
      options = [ "NOPASSWD" ];
    }];
  }];

  security.polkit.enable = true;
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      var YES = polkit.Result.YES;
      var permission = {
        "org.freedesktop.udisks2.filesystem-mount": YES,
        "org.freedesktop.udisks2.filesystem-mount-system": YES,
        "org.freedesktop.udisks2.filesystem-unmount": YES,
        "org.freedesktop.udisks2.eject-media": YES,
        "org.freedesktop.udisks2.power-off-drive": YES,
        "org.freedesktop.udisks2.filesystem-mount-other-seat": YES,
        "org.freedesktop.udisks2.encrypted-unlock": YES,
        "org.freedesktop.udisks2.encrypted-unlock-system": YES
      };
      if (subject.local && subject.active && permission[action.id]) {
        return permission[action.id];
      }
    });
  '';
}
