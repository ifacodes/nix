{ pkgs, ... }: {

  programs = {
  
    zsh = {
      enable = true;
      initExtra = builtins.readFile ./zshrc;
      oh-my-zsh = {
        enable = true;
      };
      plugins = [ ];
      syntaxHighlighting = {
        enable = true;
      };
    };

    fzf.enable = true;

    zoxide.enable = true;
    
  };

}
