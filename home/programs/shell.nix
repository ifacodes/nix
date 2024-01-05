{ ... }: {

  programs = {
  
    zsh = {
      enable = true;
      initExtra = builtins.readFile ./zshrc;
      oh-my-zsh = {
        enable = true;
      };
    };

    fzf.enable = true;

    zoxide.enable = true;
    
  };

}
