{ pkgs, lib, ... }: {
  programs.zsh = {
    enable = true;

    initContent = lib.mkBefore ''
      COMPLETION_WAITING_DOTS="true"

      export GOPATH="$HOME/.go"
      export PATH="$PATH:$HOME/.local/bin:$HOME/.cargo/bin:$HOME/.yarn/bin:$GOPATH/bin"

      export CARGO_MOMMYS_LITTLE="kitten/pet"

      # Generated for envman. Do not edit.
      [ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

      test -e "''${HOME}/.iterm2_shell_integration.zsh" && source "''${HOME}/.iterm2_shell_integration.zsh"

      export GPG_TTY=$(tty)
      export PYENV_ROOT="$HOME/.pyenv"
      command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
      eval "$(pyenv init -)"

      export NVM_DIR="$HOME/.nvm"
      [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
      [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

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

    syntaxHighlighting.enable = true;

    shellAliases = {
      ls = "eza";
      ffmpeg = "ffmpeg -hide_banner";
      gg = "git log --oneline --graph --all";
      fd = "fdfind";
      gs = "git show-branch";
      bc = "gc -lq";
    };
  };

  programs.fzf = {
    enable = true;
    # atuin owns Ctrl-R (better history-specific search); fzf keeps Ctrl-T/Alt-C
    historyWidget.command = "";
  };
}
