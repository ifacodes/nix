{ pkgs, ... }:

{
  networking.hostName = "koitar";

  systemd.network.links."10-enp34s0" = {
    matchConfig.MACAddress = "2c:f0:5d:99:73:ab";
    linkConfig.Name = "Ethernet";
  };

  networking.networkmanager.enable = true;
  networking.firewall.checkReversePath = false;
  environment.systemPackages = [ pkgs.wireguard-tools pkgs.proton-vpn ];

  time.timeZone = "America/Toronto";

  i18n.defaultLocale = "en_CA.UTF-8";

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.tailscale.enable = true;

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  services.eternal-terminal.enable = true;

  xdg.portal = {
    enable = true;
    # wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-gnome ];
    config = {
      common.default = [ "gtk" ];
      # hyprland = {
      #   default = [ "hyprland" "wlr" "gtk" ];
      #   "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
      # };
      niri = {
        default = [ "gnome" "gtk" ];
        "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
      };
    };
  };
}
