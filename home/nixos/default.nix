{ config, pkgs, lib, ... }: {
  imports = [
    ./scripts
    ./services
    ./packages.nix
    ./programs
    ./quickshell
    ./niri
  ];

  home.sessionVariables = {
    COLORTERM = "truecolor";
    NIXOS_OZONE_WL = 1;
    LIBVA_DRIVER_NAME = "radeonsi"; # AMD GPU VAAPI driver
  };

  home.shell.enableFishIntegration = true;

  xdg.configFile."uwsm/env".source = "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";

  xdg.mimeApps = {
    enable = true;
    defaultApplications = let
      desktopName = "org.libvips.vipsdisp.desktop";
      desktopFile = "${pkgs.vipsdisp}/share/applications/${desktopName}";
      mimeLine = builtins.head (builtins.filter
        (l: lib.hasPrefix "MimeType=" l)
        (lib.splitString "\n" (builtins.readFile desktopFile)));
      mimes = builtins.filter (s: s != "")
        (lib.splitString ";" (lib.removePrefix "MimeType=" mimeLine));
      imageDefaults = lib.genAttrs mimes (_: [ desktopName ]);
    in imageDefaults // {
      "inode/directory" = "org.gnome.Nautilus.desktop";
      "x-scheme-handler/mailto" = "thunderbird.desktop";
    };
  };

  home.pointerCursor = {
    enable = true;
    package = pkgs.apple-cursor;
    name = "macOS";
    size = 24;
    hyprcursor.enable = true;
    gtk.enable = true;
    x11.enable = true;
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk3";
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };
  home.stateVersion = "26.11";
}
