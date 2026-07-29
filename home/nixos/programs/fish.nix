{ pkgs, ...}:

{
  programs.fish = {
    enable = true;
    shellAliases = {
      "ls" = "eza";
      "cd" = "z";
      "rm" = "echo \"use rip instead\"";
      "cat" = "bat";
      "gg" = "git log --oneline --graph --all";
    };
    plugins = [
      {
        name = "zoxide.fish";
        src = pkgs.fetchFromGitHub {
          owner = "icezyclon";
          repo = "zoxide.fish";
          rev = "27a058a661e2eba021b90e9248517b6c47a22674";
          sha256 = "sha256-OjrX0d8VjDMxiI5JlJPyu/scTs/fS/f5ehVyhAA/KDM=";
        };
      }
    ];
  };

}
