{ pkgs, ... }: {
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    nerd-fonts._0xproto
    nerd-fonts.droid-sans-mono
    nerd-fonts.departure-mono
  ];
}
