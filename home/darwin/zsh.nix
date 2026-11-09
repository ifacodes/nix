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

      # Shell integration + utilities (imgcat, it2dl, ...) come from the app
      # bundle, so they track the installed iTerm2 instead of a stale copy in
      # $HOME that only "Install Shell Integration" ever refreshes.
      if [ "$TERM_PROGRAM" = "iTerm.app" ]; then
        iterm2_resources="/Applications/iTerm.app/Contents/Resources"
        test -r "$iterm2_resources/iterm2_shell_integration.zsh" &&
          source "$iterm2_resources/iterm2_shell_integration.zsh"
        test -d "$iterm2_resources/utilities" &&
          export PATH="$PATH:$iterm2_resources/utilities"
        unset iterm2_resources
      fi

      export GPG_TTY=$(tty)
      export PYENV_ROOT="$HOME/.pyenv"
      command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
      eval "$(pyenv init -)"

      export NVM_DIR="$HOME/.nvm"
      [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
      [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

      DISABLE_MAGIC_FUNCTIONS=true
    '';

    # Runs in place of the default bare `compinit`, so these all land after the
    # completion system is loaded.
    completionInit = ''
      autoload -U compinit && compinit
      zmodload zsh/complist

      setopt COMPLETE_IN_WORD   # complete from where the cursor is, not end of word
      setopt ALWAYS_TO_END      # ...but jump to end of word once a match is inserted
      setopt LIST_PACKED        # denser columns in the menu

      # Tab opens a navigable menu; tab/arrows move through it.
      zstyle ':completion:*' menu select

      # Try exact, then case-insensitive, then partial-word (f-b -> foo-bar),
      # then substring. Each pass only runs if the previous found nothing.
      zstyle ':completion:*' matcher-list \
        "" \
        'm:{a-z-}={A-Z_}' \
        'r:|[._-]=* r:|=*' \
        'l:|=* r:|=*'

      # Label each group of matches, so flags/files/args are told apart.
      zstyle ':completion:*' group-name ""
      zstyle ':completion:*' verbose yes
      zstyle ':completion:*:descriptions' format '%F{cyan}%B%d%b%f'
      zstyle ':completion:*:messages'     format '%F{yellow}%d%f'
      zstyle ':completion:*:warnings'     format '%F{red}no matches for %d%f'

      zstyle ':completion:*' list-colors ''${(s.:.)''${LS_COLORS:-di=1;34:ln=1;36:ex=1;32}}
      zsh_compcache="''${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompcache"
      mkdir -p "$zsh_compcache"
      zstyle ':completion:*' use-cache on
      zstyle ':completion:*' cache-path "$zsh_compcache"
      unset zsh_compcache
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

    autosuggestion = {
      enable = true;
      # when history has nothing to offer, suggest from the completion system
      strategy = [ "history" "completion" ];
    };

    syntaxHighlighting.enable = true;

    shellAliases = {
      ls = "eza";
      ffmpeg = "ffmpeg -hide_banner";
      gg = "git log --oneline --graph --all";
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
