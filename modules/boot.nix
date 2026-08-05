{ pkgs, ... }:

{
  boot.loader.systemd-boot.enable = false;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = null;
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    useOSProber = false;
    timeoutStyle = "hidden";
    fontSize = 36;
    theme = pkgs.catppuccin-grub;
    configurationLimit = 4;
    extraEntries = ''
      menuentry 'Windows' --class windows --class os {
        insmod part_gpt
        insmod fat
        search --no-floppy --fs-uuid --set=root 6064-6980
        chainloader /efi/Microsoft/Boot/bootmgfw.efi
      }
    '';
    extraConfig = ''
      insmod png
      background_image "${pkgs.catppuccin-grub}/background.png"
    '';
  };

  boot.plymouth = {
    enable = true;
    theme = "catppuccin-macchiato";
    themePackages = [ pkgs.catppuccin-plymouth ];
  };
  boot.kernelParams = [
    "quiet"
    "splash"
    "fbcon=vc:2-6"
    "console=tty0"
    "plymouth.use-simpledrm"
    "amd_pstate=guided"
  ];
  # for games like deadlock
  boot.kernel.sysctl = {
    "vm.max_map_count" = 1048576;
    "vm.oom_kill_allocating_task" = 0;
    "vm.page-cluster" = 0;
    "vm.swappiness" = 100;
    "vm.watermark_boost_factor" = 0;
    "vm.watermark_scale_factor" = 125;
  };

  boot.consoleLogLevel = 3;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.supportedFilesystems = [ "ntfs" ];
  boot.kernelModules = [ "hid-sony" "hid-playstation" ];
}
