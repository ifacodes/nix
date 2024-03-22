{ pkgs, lib, ... }: {

  programs = {
  
    zsh = {
      enable = true;
      initExtra = builtins.readFile ./zshrc;
      initExtraFirst = ''
        DISABLE_MAGIC_FUNCTIONS=true
      '';
      plugins = [
        {
          name = "zsh-nvm";
          src = pkgs.fetchFromGitHub {
            owner = "lukechilds";
            repo = "zsh-nvm";
            rev = "745291dcf20686ec421935f1c3f8f3a2918dd106";
            hash = "sha256-4O1a5bsNoqwB0hB8YU1fEVafsPQK8l7jr3GlF68ckZg=";
          };
        }
      ];
      
      syntaxHighlighting = {
        enable = true;
      };
      shellAliases = {
        ls = "eza";
        ffmpeg = "ffmpeg -hide_banner";
        gg = "git log --oneline --graph --all";
        fd = "fdfind";
        gs = "git show-branch";
        bc = "gc -lq";
      };
      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "zoxide"
        ];
      };
    };

    starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        command_timeout = 1000;
      };
    };

    fzf.enable = true;

    zoxide.enable = true;

    
    
  };

}
