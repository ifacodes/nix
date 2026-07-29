{ pkgs, config, ... }:
let s = config.scheme; in {
  gtk = {
    enable = true;
    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
    gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
    gtk3.extraCss = ''
      tooltip {
        border-radius: 12px;
      }
      tooltip.background {
        border-radius: 12px;
      }
    '';
    gtk4.extraCss = ''
      tooltip {
        border-radius: 12px;
      }
      tooltip.background {
        border-radius: 12px;
      }
    '';
  };
}
