{ config, pkgs, ... }:
let
  meowshell-lock = pkgs.writeShellScriptBin "meowshell-lock" ''
    exec qs -p ${config.xdg.configHome}/quickshell/meowshell/test.qml "$@"
  '';
in
{
  home.packages = [meowshell-lock];
  services.hypridle = {
    enable = true;

    settings = {

      general = {
          after_sleep_cmd = "niri msg action power-on-monitors";
          ignore_dbus_inhibit = false;
          lock_cmd = "QS_THEME=columbina meowshell-lock";
        };

        listener = [
          {
            timeout = 900;
            on-timeout = "QS_THEME=columbina meowshell-lock";
          }
          {
            timeout = 1200;
            on-timeout = "niri msg action power-off-monitors";
            on-resume = "niri msg action power-on-monitors";
          }
        ];

    };

  };

}
