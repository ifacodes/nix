{ 
  config, 
  pkgs, 
  lib,
  user, 
  ...
}: {

  git = {
    enable = true;
    userName = user.name;
    userEmail = user.email;
    lfs = {
      enable = true;
    };
    extraConfig = {
      init.defaultBranch = "main";
      core = {
        editor = "hx";
        autocrlf = "input";
      };
      commit.gpgsign = true;
      pull.rebase = true;
      rebase.autoStash = true;
    };
  };

  zsh = {
    enable = true;
  };
  
}
