{ pkgs, lib, inputs, hostUsers, ... }:

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
    capSysNice = true;
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

  services.dbus.packages = [ pkgs.gcr ];

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
    hashedPassword = "$y$j9T$riudkXvBx2LHzWXRJQSe/.$W.oYtP9x2KllCh.ZLz0z/SAUa0DnJGPcgxqujhBZc/.";
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
    max-jobs = 2;
    cores = 4;
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "-d";
  };

  system.stateVersion = "26.11";
}
