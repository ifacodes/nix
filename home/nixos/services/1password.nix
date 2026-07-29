{ pkgs, ... }:

{
  xdg.desktopEntries."1password" = {
    name = "1Password";
    exec = "1password --ozone-platform=x11 %U";
    terminal = false;
    type = "Application";
    icon = "1password";
    comment = "Password manager and secure wallet";
    mimeType = [ "x-scheme-handler/onepassword" ];
    categories = [ "Office" ];
  };

  systemd.user.services._1password = {
    Unit = {
      Description = "1Password";
      After = [ "graphical-session.target" "waybar.service" "tray.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "${pkgs._1password-gui}/bin/1password --silent --ozone-platform=x11";
      Restart = "on-failure";
      RestartSec = 3;
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
