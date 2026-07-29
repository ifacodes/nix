{ pkgs, lib, ... }:

{
  hardware.bluetooth = {
    enable = true;
    settings.General.Experimental = "true";
  };
  # services.blueman.enable = true;
  #
  hardware.enableRedistributableFirmware = true;
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      mesa
      libvdpau-va-gl
      libva-vdpau-driver
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [
      mesa
      libvdpau-va-gl
      libva-vdpau-driver
    ];
  };
  hardware.sane.enable = true;
  hardware.sane.extraBackends = [ pkgs.hplipWithPlugin pkgs.sane-airscan ];

  fileSystems = lib.genAttrs [ "/mnt/media" ] (path: {
    options = [
      "x-gvfs-show"
      "exec"
    ];
  });

  zramSwap.enable = true;
}
