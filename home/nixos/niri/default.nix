{ config, lib, pkgs, ... }:

let
  localBin = "${config.home.homeDirectory}/.local/bin";
in
{
  programs.niri.enable = true;

  # Use the overlay's niri-stable, which pins libdisplay-info < 0.4.0 for the
  # niri build only (see overlays/niri-libdisplay-info.nix).
  programs.niri.package = pkgs.niri-stable;
  programs.niri.settings = {

    xwayland-satellite.enable = true;

    spawn-at-startup = [
      { command = [ "sh" "-c" "QS_THEME=columbina qs -p ~/.config/quickshell/meowshell/test.qml" ]; }
      { argv = ["kitty"]; }
    ];

    screenshot-path = "${config.home.homeDirectory}/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";

    outputs."DP-1" = {
      scale = 1.0;
      variable-refresh-rate = true;
      focus-at-startup = true;

    };

    input = {
      keyboard.xkb.layout = "us";
      touchpad.natural-scroll = true;
      focus-follows-mouse = {
        enable = false;
      };
    };

    # home.pointerCursor handles xcursor theme; niri reads it from env
    cursor = {
      theme = "macOS";
      size = 36;
    };

    layout = {
      # gaps = 36;
      gaps = 128;
      struts = {
        # top = 36;
        # left = 36;
        # right = 36;
        # bottom = 36;
        top = 64;
        left = 72;
        right = 72;
        bottom = 64;
      };

      center-focused-column = "never";
      preset-column-widths = [
        { proportion = 0.33333; }
        { proportion = 0.5; }
        { proportion = 0.66667; }
      ];
      default-column-width.proportion = 0.5;
      # Use border (takes space, like Hyprland border_size) instead of focus-ring
      focus-ring = {
        enable = true;
        width = 4;
        active.gradient = {
          from="#f00f"; to="#0f05"; angle=45; in'="oklch longer hue"; relative-to="workspace-view";
        };
        inactive.gradient = {
          from="#505050"; to="#808080"; angle=45; relative-to="workspace-view";
        };
      };
      border = {
        enable = false;
        width = 2;
      };
      shadow = {
        enable = true;
        softness = 30;
        spread = 5;
        offset = { x = 0; y = 5; };
        color = "#0007";
      };
      tab-indicator = {
        enable = true;
        width = 12;
        gap = 7;
        corner-radius = 12.0;
        place-within-column = true;
      };
      insert-hint = {
        enable = true;
      };
      background-color = "transparent";
    };

    prefer-no-csd = true;
    animations.enable = true;

    layer-rules = [
      {
        matches = [ {namespace = "launcher";} ];
        background-effect = {
          blur = true;

        };
      }
      {
        matches = [ { namespace = "^meowshell.wallpaper$"; }];
        place-within-backdrop = true;
      }
    ];

    blur = {
      enable = true;
      passes = 2;
      noise = 0.08;
      offset = 3;
      saturation = 0.9;
    };

    workspaces = {
      "1" = {
        open-on-output = "DP-1";
        name = "code";
      };
      "2" = {
        name = "browsing";
        open-on-output = "DP-1";
      };
      "3" = {
        name = "gaming";
        open-on-output = "DP-1";
      };
    };

    window-rules = [
      # Match Hyprland's active_opacity=1.0 / inactive_opacity=0.85
      {
        matches = [ { } ];
        opacity = 0.85;
        geometry-corner-radius = {
          top-left = 12.0;
          top-right = 12.0;
          bottom-left = 12.0;
          bottom-right = 12.0;
        };
        clip-to-geometry = true;
      }
      { matches = [ { is-focused = true; } ]; opacity = 1.0; }

      # pavucontrol
      { matches = [ { title = "^Volume Control$"; } ]; open-floating = true; }

      # 1Password quick access — float, don't steal focus
      {
        matches = [ { app-id = "^1password$"; title = "^Quick Access — 1Password$"; } ];
        open-floating = true;
        open-focused = true;
      }

      {
        matches = [ {app-id = "1password"; } ];
        block-out-from = "screen-capture";
      }

      # 1Password main window
      {
        matches = [ { app-id = "^1password$"; title = "^1Password$"; } ];
        open-floating = true;
        default-column-width.proportion = 0.5;
      }

      # PrismLauncher console
      {
        matches = [ { app-id = ".*PrismLauncher.*"; title = ".*Console window for.*"; } ];
        open-floating = true;
      }

      # kitty — float and center (override per-workspace if needed)
      { matches = [ { app-id = "^kitty$"; } ]; open-floating = true; }
      { matches = [ { at-startup = true; app-id = "^kitty$"; } ]; open-on-workspace = "code"; tiled-state = true; }

      # meowshell settings panel
      { matches = [ { title = "^meowshell-settings$"; } ]; open-floating = true; }
      {
        matches = [ {app-id = "steam"; title = "^notificationtoasts_\\d+_desktop$"; }];
        default-floating-position = {
          x = 10;
          y = 10;
          relative-to = "bottom-right";
        };
      }
    ];

    binds =
      let
        workspaceBinds = lib.mergeAttrsList (map (i: {
          "Mod+${toString i}".action.focus-workspace = i;
          "Mod+Shift+${toString i}".action.move-window-to-workspace = i;
        }) (lib.range 4 9));
      in
      {
        "Mod+Shift+Slash".action.show-hotkey-overlay = {};
        # Launchers
        "Mod+D".action.spawn = [ "fuzzel" ];
        "Mod+T" = {
          hotkey-overlay.title = "Open a Terminal: kitty";
          action.spawn = [ "kitty" ];
        };
        # Hyprland movetoroot (swap to dwindle root) → center column in niri's scrollable model
        "Mod+Return".action.center-column = { };
        "Ctrl+Shift+Space".action.spawn = [ "1password" "--quick-access" ];
        "Mod+Slash".action.spawn = [ "1password" ];
        "Mod+Q" = {
          repeat = false;
          action.close-window = { };
        };
        # "Mod+N".action.spawn = [ "quickshell" "ipc" "call" "toggleNotifCenter" "toggleNotifCenter" ];
        "Mod+Shift+E".action.spawn = [ "${localBin}/power-menu" ];
        "Mod+Shift+S".action.spawn = [ "${localBin}/screenshot-menu" ];

        "Mod+O" = {
          repeat = false;
          action.toggle-overview = {};
        };

        "Mod+R".action.switch-preset-column-width = {};
        "Mod+Shift+R".action.switch-preset-column-width-back = {};
        # Window focus — Left/Right move between columns, Up/Down move within a column
        "Mod+Left".action.focus-column-left = { };
        "Mod+Right".action.focus-column-right = { };
        "Mod+Up".action.focus-window-or-workspace-up = { };
        "Mod+Down".action.focus-window-or-workspace-down = { };

        # Window/column movement
        "Mod+Shift+Left".action.move-column-left = { };
        "Mod+Shift+Right".action.move-column-right = { };
        "Mod+Shift+Up".action.move-window-up-or-to-workspace-up = { };
        "Mod+Shift+Down".action.move-window-down-or-to-workspace-down = { };

        "Mod+Control+Up".action.move-workspace-up = {};
        "Mod+Control+Down".action.move-workspace-down = {};

        # Toggle floating / fullscreen
        "Mod+Space".action.toggle-window-floating = { };
        "Mod+F".action.maximize-column = { };
        "Mod+Shift+F".action.fullscreen-window = {};
        "Mod+M".action.maximize-window-to-edges = {};
        "Mod+Ctrl+F".action.expand-column-to-available-width = {};
        "Mod+C".action.center-column = {};
        "Mod+Ctrl+C".action.center-visible-columns = {};

        "Ctrl+Alt+Delete".action.quit = {};

        # Column grouping — niri's equivalent of Hyprland groups
        # Mod+G: pull next window into current column (stack)
        # Mod+Shift+G / Mod+Ctrl+G: cycle focus within a column
        "Mod+G".action.toggle-column-tabbed-display = { };
        "Mod+Shift+G".action.focus-window-down = { };
        "Mod+Ctrl+G".action.focus-window-up = { };

        "Mod+WheelScrollDown" = {
          cooldown-ms = 150;
          action.focus-window-or-workspace-down = {};
        };
        "Mod+WheelScrollUp" = {
          cooldown-ms = 150;
          action.focus-window-or-workspace-up = {};
        };
        "Mod+Shift+WheelScrollDown" = {
          cooldown-ms = 150;
          action.focus-column-right = {};
        };
        "Mod+Shift+WheelScrollUp" = {
          cooldown-ms = 150;
          action.focus-column-left = {};
        };

        # Media
        "XF86AudioRaiseVolume" = {
          allow-when-locked = true;
          action.spawn = [ "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1+" "-l" "1.0" ];
        };
        "XF86AudioLowerVolume" = {
          allow-when-locked = true;
          action.spawn = [ "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1-" ];
        };
        "XF86AudioPlay" = {
          allow-when-locked = true;
          action.spawn = [ "playerctl" "play-pause" ];
        };
        "XF86AudioPause" = {
          allow-when-locked = true;
          action.spawn = [ "playerctl" "play-pause" ];
        };
        "XF86AudioNext" = {
          allow-when-locked = true;
          action.spawn = [ "playerctl" "next" ];
        };
        "XF86AudioPrev" = {
          allow-when-locked = true;
          action.spawn = [ "playerctl" "previous" ];
        };

        "Mod+1".action.focus-workspace = "code";
        "Mod+Shift+1".action.move-window-to-workspace = "code";
        "Mod+2".action.focus-workspace = "browsing";
        "Mod+Shift+2".action.move-window-to-workspace = "browsing";
        "Mod+3".action.focus-workspace = "gaming";
        "Mod+Shift+3".action.move-window-to-workspace = "gaming";

      } // workspaceBinds;

  };

  services.gnome-keyring.enable = lib.mkForce false;

  systemd.user.services.onepassword = {
    Unit = {
      Description = "1Password background";
      After = [ "graphical-session.target" ];
      Requisite = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs._1password-gui}/bin/1password --silent";
      Restart = "on-failure";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };

}
