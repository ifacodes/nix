final: prev:
let
  # Fetch from nixpkgs master branch for claude-code 2.1.20
  pkgs-master = import (prev.fetchFromGitHub {
    owner = "NixOS";
    repo = "nixpkgs";
    rev = "5961d0e477173b2e1d7dd32cae3873e7c3a65e79"; # master with claude-code 2.1.20
    sha256 = "sha256-fpNQSodPbC6K54i4/gpOtphJoJAY1HfwutaeSeJTu5o=";
  }) {
    system = prev.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };
in
{
  # Pull claude-code CLI from master
  claude-code = pkgs-master.claude-code;

  # Pull vscode extension from master
  vscode-extensions = prev.vscode-extensions // {
    anthropic = prev.vscode-extensions.anthropic // {
      claude-code = pkgs-master.vscode-extensions.anthropic.claude-code;
    };
  };
}
