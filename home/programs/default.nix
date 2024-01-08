{ pkgs, ... }: {
  imports = [
    ./git.nix
    ./shell.nix
    ./eza.nix      
  ];
}
