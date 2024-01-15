{ pkgs, ... }: {
  imports = [
    ./git.nix
    ./shell.nix
    ./eza.nix
    ./fonts.nix      
  ];
}
