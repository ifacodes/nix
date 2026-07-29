{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    mutableExtensionsDir = false;
    profiles.default = {
      extensions = with pkgs.vscode-marketplace; [
        rust-lang.rust-analyzer
        anthropic.claude-code
        mkhl.direnv

      ];
      userSettings = {
        "rust-analyzer.server.path" = "${pkgs.fenix.complete.toolchain}/bin/rust-analyzer";
        "window.zoomLevel" = 1;
        "editor.fontFamily" = "'DepartureMono Nerd Font Mono', monospace";
        "editor.fontSize" = 16.5;
      };
    };
  };

  xdg.dataFile."icons/hicolor/1024x1024/apps/vscode.png".source =
    "${pkgs.vscode}/share/icons/hicolor/1024x1024/apps/vscode.png";
  xdg.dataFile."icons/hicolor/512x512/apps/vscode.png".source =
    "${pkgs.vscode}/share/icons/hicolor/1024x1024/apps/vscode.png";
  xdg.dataFile."icons/hicolor/256x256/apps/vscode.png".source =
    "${pkgs.vscode}/share/icons/hicolor/1024x1024/apps/vscode.png";
  xdg.dataFile."icons/hicolor/128x128/apps/vscode.png".source =
    "${pkgs.vscode}/share/icons/hicolor/1024x1024/apps/vscode.png";
  xdg.dataFile."icons/hicolor/48x48/apps/vscode.png".source =
    "${pkgs.vscode}/share/icons/hicolor/1024x1024/apps/vscode.png";
}
