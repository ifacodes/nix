{ pkgs, lib, inputs, hostUsers, config, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/boot.nix
    ../../modules/theming.nix
    ../../modules/hardware.nix
    ../../modules/audio.nix
    ../../modules/networking.nix
    ../../modules/security.nix
  ];

  # read-only APFS, for mounting Mac drives
  boot.extraModulePackages = [ config.boot.kernelPackages.apfs ];
  # apfs module doesn't build on 7.3 yet (inode_operations.create signature change)
  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_7_2;

  virtualisation.libvirtd.enable = true;
  virtualisation.docker.enable = true;
  programs.virt-manager.enable = true;

  programs.fish.enable = true;
  programs.dconf.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    protontricks.enable = true;
    localNetworkGameTransfers.openFirewall = true;
    extest.enable = true;
    gamescopeSession.enable = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
    LD_LIBRARY_PATH = lib.mkBefore [ "${pkgs.openssl.out}/lib" ];
  };

  programs.gamemode.enable = true;

  programs.gamescope = {
    enable = true;
    capSysNice = false;
  };

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "ifa" ];
  };

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [ openssl ];
  };

  programs.java = {
    enable = true;
    package = pkgs.jdk25;
  };

  programs.gnupg.agent.enable = true;

  services.dbus.packages = [ pkgs.gcr_3 ];

  services.kmscon = {
    enable = true;
    config = {
      font-name = "DepartureMono Nerd Font Mono";
      font-size=22;
      xkb-layout="us";
      hwaccel = true;
    };
  };

  services.printing = {
    enable = true;
    drivers = with pkgs; [ hplip ];
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  services.gvfs.enable = true;
  services.udisks2.enable = true;

  services.udev.extraRules = ''
    ENV{ID_SERIAL_SHORT}=="S6S1NJ0RB15119Z", ENV{UDISKS_IGNORE}="1"
  '';

  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.niri-stable}/bin/niri-session";
      user = "ifa";
    };
  };

  services.scx-loader = {
    enable = true;
    config = {
      default_sched = "scx_lavd";
      default_mode = "Gaming";

      scx_lavd = {
        auto_mode = [ "--performance" ];
      };
    };
  };


  users.mutableUsers = false;

  age.secrets.ifa-password.file = ../../secrets/ifa-password.age;
  age.secrets.woodshed-koitar-key.file = ../../secrets/woodshed-koitar-key.age;
  age.secrets.woodshed-iphone-key.file = ../../secrets/woodshed-iphone-key.age;
  age.secrets.woodshed-p12-password.file = ../../secrets/woodshed-p12-password.age;

  users.users = lib.genAttrs hostUsers (name: {
    isNormalUser = true;
    description = "Aoife Bradley";
    shell = pkgs.fish;
    extraGroups = [
      "networkmanager"
      "wheel"
      "audio"
      "video"
      "seat"
      "storage"
      "input"
      "scanner"
      "lp"
      "docker"
    ];
    hashedPasswordFile = config.age.secrets.ifa-password.path;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB9+W/cjdW4fKLLwQ9JnzOwAuGq9WzPRCeb69KiaHVXL"
    ];
  });

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    wget
    git
    jujutsu
    gnupg
    pinentry-curses
    scarlett2
    fastfetch
    gcc
    alsa-scarlett-gui
    bitwig-studio
    libva-utils
    openssl
    openssl.dev
    pkg-config
    affinity-photo
    affinity-designer
    affinity-publisher
  ];

  nix.package = pkgs.lixPackageSets.latest.lix;
  nix.settings = {
    max-jobs = 1;
    cores = 8;
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    extra-substituters = [
      "https://niri-epireyn.cachix.org"
      "https://cache.forall.systems"
    ];
    extra-trusted-public-keys = [
      "niri-epireyn.cachix.org-1:tlVyFN7CtsDT+ZcLPS+ekFWeT1X6X4OqvWqbBMyIzFA="
      "cache.forall.systems:5PmD7QO4MSF8YgyRZtkSGXRDo96H3bybIf2SsQh8ScI="
    ];
  };

  programs.nh = {
    enable = true;
    flake = "/home/ifa/.config/nixos";
    clean = {
      enable = true;
      dates = "weekly";
      extraArgs = "--keep 5 --keep-since 7d";
    };
  };

  system.stateVersion = "26.11";
}
