{ ... }:

{
  programs.rofi = {
    enable = true;
    terminal = "kitty";
    extraConfig = {
      modi = "drun,run,window";
      show-icons = true;
      icon-theme = "Adwaita";
      drun-display-format = "{name}";
      display-drun = " > ";
      display-run = " > ";
      display-window = " > ";
    };
  };
}
