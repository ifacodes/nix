{ pkgs, inputs, ... }:
let
  qsPkg = inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default.withModules [
    pkgs.qt6.qtdeclarative
    pkgs.qt6.qtsvg
    pkgs.qt6.qtimageformats
    pkgs.qt6.qtmultimedia
    pkgs.qt6.qt5compat
  ];
in {

  programs.quickshell = {
    enable = true;
    systemd.enable = true;
    package = qsPkg;
    activeConfig = "meowshell";
  };

  # qmlls needs quickshell's QML modules on the import path.
  # The -E flag tells qmlls to read QML_IMPORT_PATH from the environment.
  # home.packages = [ pkgs.qt6.qtdeclarative ];
  home.sessionVariables.QML_IMPORT_PATH = pkgs.lib.concatStringsSep ":" [
    "${qsPkg}/lib/qt-6/qml"
  ];


}
