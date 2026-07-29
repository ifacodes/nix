{ config, lib, scheme, ...}:
let s = scheme; in
{
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        dpi-aware = false;
        prompt = " ► ";
        icon-theme = "Adwaita";
        icons-enabled = true;
        terminal = "kitty";
        anchor = "center";
        # lines = 10;
        # width = 40;
        # tabs = 3;
        horizontal-pad = 4;
        vertical-pad = 4;
        inner-pad = 5;
      };
      border = {
        width = 12;
        radius = 10;
      };
      colors = {
        background = "${s.base00}DD";
        text = "${s.base05}FF";
        match = "${s.base0D}FF";
        selection = "${s.base02}FF";
        selection-text = "${s.base05}FF";
        selection-match = "${s.base0D}FF";
        border = "${s.base00}D8";
      };
    };
  };
}
