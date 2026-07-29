{ pkgs, inputs, ... }: {

  scheme = "${inputs.tt-schemes}/base24/catppuccin-mocha.yaml";

  fonts.packages = with pkgs; [
    nerd-fonts.departure-mono
    noto-fonts
    noto-fonts-color-emoji
  ];

  environment.systemPackages = [
    pkgs.apple-cursor
  ];

  environment.variables = {
    HYPRCURSOR_THEME = "macOS";
    HYPRCURSOR_SIZE = "24";
  };


     # image = pkgs.fetchurl {
     #   url = "https://pbs.twimg.com/media/G-6UoRkW0AAs52b?format=jpg&name=4096x4096";
     #   hash = "sha256-nNvphSe8LGxhnRhMlPEqtFN67WvaJJwv4cq/pRuuKpM=";
     #   name = "wallpaper.jpg";
     # };

    # icons = {
    #   dark = "Adwaita";
    #   light = "Adwaita";
    # };
}
