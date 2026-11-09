{ ... }: {
  imports = [
    ./zsh.nix
    ./packages.nix
    ./fonts.nix
    ./ssh.nix
    ./vscodium.nix
  ];

  home.stateVersion = "26.11";
}
