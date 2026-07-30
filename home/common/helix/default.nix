{config, lib, pkgs, scheme ? null, ...}:

{

  xdg.desktopEntries.Helix = lib.mkIf pkgs.stdenv.isLinux {
    name = "Helix";
    genericName = "Text Editor";
    exec = "kitty hx %F";
    terminal = false;
    type = "Application";
    icon = "helix";
    categories = [ "Utility" "TextEditor" ];
    mimeType = [ "text/english" "text/plain" "text/x-makefile" "text/x-c++hdr" "text/x-c++src" "text/x-chdr" "text/x-csrc" "text/x-java" "text/x-moc" "text/x-pascal" "text/x-tcl" "text/x-tex" "application/x-shellscript" "text/x-c" "text/x-c++" ];
  };

  xdg.configFile."helix/runtime/queries/qml/indents.scm".text = ''
  [
    (enum_body)
    (ui_object_initializer)
    (statement_block)
  ] @indent

  "}" @outdent
'';

  programs.helix = {
    enable = true;
    defaultEditor = true;

    themes = lib.optionalAttrs (scheme != null) {
      base24 = lib.importTOML (scheme {
        templateRepo = fetchGit {
          url = "https://github.com/tinted-theming/tinted-helix";
          narHash = "sha256-E3OAK27smtATTmX45uoTSRsVD+Y+ZiVVfgM/tjpbtYg=";
        };
        target = "base24";
      });
    };

    languages = {
      language-server.vscode-css-language-server = {
        config = {
          css = {
            validate = true;
          };
        };
      };

      language-server.qml-language-server = {
        command = "qml-language-server";
      };

      language = [
        {
          name = "css";
          language-servers = [ "vscode-css-language-server" ];
        }
        {
          name = "qml";
          language-servers = [ "qml-language-server" ];
          auto-format = true;
          # indent = { tab-width = 2; unit = "\t"; };
          file-types = [ "qml" ];
        }
        {
          name = "nix";
          formatter = { command = "nixfmt"; };
          auto-format = true;
        }
      ];
    };

    settings = {
      theme = if scheme != null then "base24" else "onedark";
      editor = {
        line-number = "relative";
        mouse = true;
        rulers = [120];
        true-color = true;
        completion-replace = true;
        trim-trailing-whitespace = true;
        end-of-line-diagnostics = "hint";
        color-modes = true;

        inline-diagnostics = {
          cursor-line = "warning";
        };

        file-picker = {
          hidden = false;
        };

        indent-guides = {
          render = true;
          character = "╎";
          skip-levels = 0;
        };

        soft-wrap = {
          enable = false;
        };

        auto-save = {
          focus-lost = false;
          after-delay = {
            enable = true;
            timeout = 300000;
          };
        };

        lsp = {
          display-color-swatches = true;
        };

        statusline = {
          left = [
            "mode"
            "spinner"
            "version-control"
            "spacer"
            "separator"
            "file-name"
            "read-only-indicator"
            "file-modification-indicator"
          ];
          center = [];
          right = [
            "diagnostics"
            "workspace-diagnostics"
            "position"
            "total-line-numbers"
            "position-percentage"
            "file-encoding"
            "file-line-ending"
            "file-type"
            "register"
            "selections"
          ];
        };
      };

      keys.normal."+" = {
        f = ":format";
      };
    };
  };

}
