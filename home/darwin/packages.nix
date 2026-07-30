{ pkgs, ... }: {
  home.enableNixpkgsReleaseCheck = false;

  home.packages = with pkgs; [
    sl
    mariadb
    fastfetch
    w3m
    libsixel
    imagemagickBig
    binutils
    rsync

    # migrated from Homebrew (2026-07-29)
    go
    helix
    ffmpeg
    catimg
    dust
    yt-dlp
    android-tools
    eternal-terminal
    nmap
    jq
    pyenv
    xxhash
    redis
    qmk
    orbstack
    syncplay

    # remainder of Homebrew catalog, migrated 2026-07-29
    arp-scan
    automake
    avrdude
    cmake
    croc
    dotnet-sdk
    duti
    fd
    gnupg
    grpcurl
    guile
    innoextract
    jdupes
    (jp2a.overrideAttrs (o: { meta = o.meta // { broken = false; }; }))
    libplacebo
    usbutils
    meson
    neovim
    nghttp2
    php
    qrencode
    stress
    inetutils
    vapoursynth
    wgcf
    wimlib
    wireguard-tools
    python3
    texlive.combined.scheme-basic
  ];
}
