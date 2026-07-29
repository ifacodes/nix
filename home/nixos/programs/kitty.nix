{ lib, pkgs, scheme, ...}:

{
  programs.kitty = {
    enable = true;
    font = {
      name = "DepartureMono Nerd Font Mono";
      size = 16.5;
    };
    settings = {
      confirm_os_window_close = 0;
      scrollback_lines = 10000;
      scrollbar = "scrolled-and-hovered";
      scrollbar_interactive = "yes";
      scrollbar_jump_on_click = true;
      tab_bar_style = "powerline";
      tab_powerline_style = "round";
      startup_session = "~/.config/kitty/sessions/default_session";
      allow_remove_control = "yes";

      window_padding_width = 50;

       # colors
      background            = "#${scheme.base00}";
      foreground            = "#${scheme.base05}";
      selection_background  = "#${scheme.base02}";
      selection_foreground  = "#${scheme.base05}";
      cursor                = "#${scheme.base05}";
      cursor_text_color     = "#${scheme.base00}";
      url_color             = "#${scheme.base0D}";

      # black
      color0  = "#${scheme.base00}";
      color8  = "#${scheme.base03}";
      # red
      color1  = "#${scheme.base08}";
      color9  = "#${scheme.base08}";
      # green
      color2  = "#${scheme.base0B}";
      color10 = "#${scheme.base0B}";
      # yellow
      color3  = "#${scheme.base0A}";
      color11 = "#${scheme.base0A}";
      # blue
      color4  = "#${scheme.base0D}";
      color12 = "#${scheme.base0D}";
      # magenta
      color5  = "#${scheme.base0E}";
      color13 = "#${scheme.base0E}";
      # cyan
      color6  = "#${scheme.base0C}";
      color14 = "#${scheme.base0C}";
      # white
      color7  = "#${scheme.base05}";
      color15 = "#${scheme.base07}";

      # tabs
      active_tab_background   = "#${scheme.base0D}";
      active_tab_foreground   = "#${scheme.base00}";
      inactive_tab_background = "#${scheme.base01}";
      inactive_tab_foreground = "#${scheme.base03}";
    };
    keybindings = {
      "kitty_mod+alt+s" = "save_as_session --use-foreground-process --save-only --base-dir  ~/.config/kitty/sessions";
    };
    enableGitIntegration = true;
    shellIntegration.enableFishIntegration = true;
  };

  home.file.".config/kitty/float_video.py".text = ''
    import argparse
    import json
    import os
    import re
    import subprocess
    import sys
    import time

    MAX_W = 960
    MAX_H = 540
    CLASS = "float-video"
    IMAGE_EXTS = {".png", ".jpg", ".jpeg", ".gif", ".bmp", ".webp", ".tiff", ".tif", ".avif"}


    def get_image_size(path):
        """Read image dimensions quickly via ImageMagick identify (header only)."""
        try:
            r = subprocess.run(
                ["identify", "-format", "%w %h", f"{path}[0]"],
                capture_output=True, text=True, timeout=5,
            )
            m = re.match(r"(\d+) (\d+)", r.stdout.strip())
            if m:
                w, h = int(m.group(1)), int(m.group(2))
                if w > 0 and h > 0:
                    return w, h
        except Exception:
            pass
        return MAX_W, MAX_H


    def get_video_size(path):
        """Query native video dimensions using mpv --vo=null."""
        try:
            r = subprocess.run(
                [
                    "mpv", "--no-config", "--vo=null", "--ao=null", "--frames=1",
                    "--term-playing-msg=FLOAT_VIDEO_SIZE ''${=video-params/dw} ''${=video-params/dh}",
                    path,
                ],
                capture_output=True, text=True, timeout=10,
            )
            m = re.search(r"FLOAT_VIDEO_SIZE (\d+) (\d+)", r.stdout + r.stderr)
            if m:
                w, h = int(m.group(1)), int(m.group(2))
                if w > 0 and h > 0:
                    return w, h
        except Exception:
            pass
        return MAX_W, MAX_H


    def clamp_size(w, h):
        """Scale down to fit within MAX_W x MAX_H, preserving aspect ratio."""
        if w <= MAX_W and h <= MAX_H:
            return w, h
        scale = min(MAX_W / w, MAX_H / h)
        return int(w * scale), int(h * scale)


    def main(args):
        parser = argparse.ArgumentParser(prog="float_video")
        parser.add_argument("file", help="path to video/image file")
        parser.add_argument("--scale", type=float, default=1.0, help="scale factor (default: 1.0)")
        opts = parser.parse_args(args[1:])

        video_path = os.path.expanduser(opts.file)
        if not os.path.exists(video_path):
            print(f"float_video: not found: {video_path}", file=sys.stderr)
            raise SystemExit(1)

        is_image = os.path.splitext(video_path)[1].lower() in IMAGE_EXTS
        raw_w, raw_h = get_image_size(video_path) if is_image else get_video_size(video_path)
        base_w, base_h = clamp_size(raw_w, raw_h)
        win_w = max(1, int(base_w * opts.scale))
        win_h = max(1, int(base_h * opts.scale))

        # Resolve top-right position on the focused monitor
        try:
            monitors = json.loads(subprocess.check_output(["hyprctl", "monitors", "-j"]))
            mon = next((m for m in monitors if m.get("focused")), monitors[0])
            scale = float(mon.get("scale", 1))
            logical_w = int(mon["width"] / scale)
            x = mon["x"] + logical_w - win_w
            y = mon["y"]
        except Exception as e:
            print(f"float_video: hyprctl error ({e}), defaulting position to 1280 0", file=sys.stderr)
            x, y = 1280, 0

        # Spawn a detached Kitty window using mpv for both images and video.
        # icat renders before hyprctl can resize the window, so mpv is used for
        # images too — it responds to SIGWINCH and re-renders after the resize.
        subprocess.Popen(
            [
                "kitty",
                f"--class={CLASS}",
                f"--title={CLASS}",
                "--override", "window_padding_width=0",
                "--",
                "mpv",
                "--vo=kitty",
                f"--vo-kitty-width={win_w}",
                f"--vo-kitty-height={win_h}",
                "--image-display-duration=inf" if is_image else "--loop-file=inf",
                "--really-quiet",
                "--no-osc",
                video_path,
            ],
            start_new_session=True,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        )

        # Poll for the window to appear, then float / size / position / pin it
        DEVNULL = {"stdout": subprocess.DEVNULL, "stderr": subprocess.DEVNULL}
        for _ in range(40):
            time.sleep(0.1)
            try:
                clients = json.loads(subprocess.check_output(["hyprctl", "clients", "-j"]))
            except Exception:
                continue
            win = next((w for w in clients if w.get("class") == CLASS or w.get("initialClass") == CLASS or w.get("title") == CLASS), None)
            if win:
                raw = win["address"]
                addr = raw if raw.startswith("0x") else "0x" + raw
                w = f'address:{addr}'
                subprocess.run(["hyprctl", "dispatch", f'hl.dsp.window.float({{action = "on", window = "{w}"}})'], **DEVNULL)
                subprocess.run(["hyprctl", "dispatch", f'hl.dsp.window.resize({{x = {win_w}, y = {win_h}, relative = false, window = "{w}"}})'], **DEVNULL)
                subprocess.run(["hyprctl", "dispatch", f'hl.dsp.window.move({{x = {x}, y = {y}, relative = false, window = "{w}"}})'], **DEVNULL)
                subprocess.run(["hyprctl", "dispatch", f'hl.dsp.window.pin({{window = "{w}"}})'], **DEVNULL)
                break


    handle_result = None
  '';

  home.file.".config/kitty/sessions/default_session".text = ''
    new_tab fretboard app
    layout fat
    enabled_layouts fat,grid,horizontal,splits,stack,tall,vertical
    set_layout_state {"main_bias": [0.5, 0.5], "biased_map": {}, "opts": {"full_size": 1, "bias": 50, "mirrored": "n"}, "class": "Fat", "all_windows": {"active_group_idx": 0, "active_group_history": [1], "window_groups": [{"id": 1, "window_ids": [1]}]}}
    cd /home/ifa/projects/fretboard-v2

    launch 'kitty-unserialize-data={"id": 1}' /etc/profiles/per-user/ifa/bin/cargo run
    focus

    new_tab
    layout fat
    enabled_layouts fat,grid,horizontal,splits,stack,tall,vertical
    set_layout_state {"main_bias": [0.5, 0.5], "biased_map": {}, "opts": {"full_size": 1, "bias": 50, "mirrored": "n"}, "class": "Fat", "all_windows": {"active_group_idx": 0, "active_group_history": [2], "window_groups": [{"id": 2, "window_ids": [2]}]}}
    cd /home/ifa

    launch 'kitty-unserialize-data={"id": 2}'
    focus


    new_tab
    layout fat
    enabled_layouts fat,grid,horizontal,splits,stack,tall,vertical
    set_layout_state {"main_bias": [0.5, 0.5], "biased_map": {}, "opts": {"full_size": 1, "bias": 50, "mirrored": "n"}, "class": "Fat", "all_windows": {"active_group_idx": 0, "active_group_history": [3], "window_groups": [{"id": 3, "window_ids": [3]}]}}
    cd /home/ifa/.config/nixos

    launch 'kitty-unserialize-data={"id": 3}'
    focus

    focus_tab 0
      '';
}
