{pkgs, inputs, ...}:

{
  home.packages = with pkgs; [
    # Wrap Google Chrome with Wayland and hardware acceleration flags
    (google-chrome.override {
      commandLineArgs = [
        # Wayland support
        "--ozone-platform=wayland"
        "--enable-wayland-ime"

        # Vulkan-based rendering and video decode
        "--enable-features=Vulkan,DefaultANGLEVulkan,VulkanFromANGLE"
        "--use-angle=vulkan"
        "--use-vulkan=native"

        # Enable hardware video decode
        "--enable-accelerated-video-decode"
        "--ignore-gpu-blocklist"
      ];
    })
    noto-fonts
    noto-fonts-color-emoji
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    nerd-fonts.departure-mono
    zpix-pixel-font
    wl-clipboard
    nixd
    grim
    slurp
    claude-code
    libnotify
    pavucontrol
    spotify
    (pkgs.symlinkJoin {
      name = "prismlauncher";
      paths = [ inputs.prismlauncher.packages.${stdenv.hostPlatform.system}.prismlauncher ];
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/prismlauncher \
          --unset QT_QPA_PLATFORMTHEME \
          --set QT_STYLE_OVERRIDE fusion
      '';
    })
    hicolor-icon-theme
    adwaita-icon-theme
    papirus-icon-theme
    playerctl
    fenix.stable.toolchain
    lldb
    nautilus
    fractal
    signal-desktop
    telegram-desktop
    tor-browser
    rip2
    vscode-css-languageserver
    hyprprop
    hyprpicker
    jq
    vips
    vipsdisp
    xdotool
    transmission_4-qt
    hyprshutdown
    furnace
    zenity
    inputs.qml-language-server.packages.${stdenv.hostPlatform.system}.default
    xwayland-satellite
    imv
    zathura
    wf-recorder
    (heroic.override {
      extraPkgs = pkgs': with pkgs'; [
        gamemode
        gamescope
      ];
    })
    # CLion 2026.2 bundles its own libstdc++.so.6 under
    # plugins/remote-dev-server/selfcontained/lib. The builder deletes that dir
    # from $out during installPhase but leaves it in the build tree, so
    # autoPatchelfHook still finds it and bakes the sandbox path
    # /build/clion-*/plugins/remote-dev-server/selfcontained/lib into the RPATH
    # of every binary needing libstdc++ (clangd, clang-tidy, gdb, lldb, ninja).
    # That path doesn't exist at runtime, so they all fail to start. Drop the
    # bundled copy before fixup so gcc's libstdc++ is used instead.
    #
    # Separately: ANGLE (inside the bundled jcef plugin) dlopens libGL.so.1 by
    # soname at runtime. libGL is in the builder's buildInputs, which only fixes
    # DT_NEEDED refs, so nothing puts libglvnd on the search path and ANGLE
    # fails to initialise. appendRunpaths adds it to every patched ELF, which is
    # what's needed here: runtimeDependencies only applies to executables, and
    # dlopen resolves against the calling library's own RUNPATH.
    (jetbrains.clion.overrideAttrs (old: {
      preFixup = (old.preFixup or "") + ''
        rm -rf plugins/remote-dev-server/selfcontained
      '';
      appendRunpaths = (old.appendRunpaths or [ ]) ++ [ "${libglvnd}/lib" ];
    }))
  ];

  fonts.fontconfig.enable = true;
}
