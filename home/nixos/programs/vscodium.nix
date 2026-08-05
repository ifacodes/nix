{ pkgs, ... }:

{
  # Extensions and settings are both managed in the app itself, so nothing is
  # declared here beyond the package: the extensions dir and settings.json have
  # to stay writable.
  programs.vscodium = {
    enable = true;
    package = pkgs.vscodium;
    mutableExtensionsDir = true;
  };

  xdg.dataFile."icons/hicolor/1024x1024/apps/vscodium.png".source =
    "${pkgs.vscodium}/share/icons/hicolor/1024x1024/apps/vscodium.png";
  xdg.dataFile."icons/hicolor/512x512/apps/vscodium.png".source =
    "${pkgs.vscodium}/share/icons/hicolor/1024x1024/apps/vscodium.png";
  xdg.dataFile."icons/hicolor/256x256/apps/vscodium.png".source =
    "${pkgs.vscodium}/share/icons/hicolor/1024x1024/apps/vscodium.png";
  xdg.dataFile."icons/hicolor/128x128/apps/vscodium.png".source =
    "${pkgs.vscodium}/share/icons/hicolor/1024x1024/apps/vscodium.png";
  xdg.dataFile."icons/hicolor/48x48/apps/vscodium.png".source =
    "${pkgs.vscodium}/share/icons/hicolor/1024x1024/apps/vscodium.png";
}
