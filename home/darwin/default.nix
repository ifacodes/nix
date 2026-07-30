{ ... }: {
  imports = [
    ./zsh.nix
    ./packages.nix
    ./fonts.nix
    ./ssh.nix
  ];

  home.stateVersion = "26.11";
}
