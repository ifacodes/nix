{ 
  config, 
  pkgs, 
  lib,
  name,
  user,
  email, 
  ...
}: {

  git = {
    enable = true;
    userName = name;
    userEmail = email;
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

  # zsh = {
  #   enable = true;
  # };
  
}
