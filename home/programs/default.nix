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
    signing.key = "31BAA9F06D08C088";
    lfs = {
      enable = true;
    };
    extraConfig = {
      init.defaultBranch = "main";
      core = {
        editor = "hx";
        # autocrlf = "input";
      };
      commit.gpgsign = true;
      #gpg.program = "/opt/homebrew/bin/gpg";
      pull.rebase = true;
      push.default = "current";
      rebase.autoStash = true;
      merge.conflictstyle = "diff3";
      diff.algorithm = "histogram";
      fetch.prune = true;
    };
    aliases = {
      pushf = "push --force-with-lease";
    };
    # includes = [ {path = "~/.gitconfig";} ];
  };

  zsh = {
    enable = true;
    initExtra = builtins.readFile ./zshrc;
  };
  
}
