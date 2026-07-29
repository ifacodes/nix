{ ... }:

{

  home.file.".local/bin/screenshot-menu" = {
    text = ''
      #!/bin/sh

      selected=$(echo -e "Select\nScreen\nOutput" | \
        fuzzel --dmenu \
        --hide-prompt \
        --width 30 \
        --lines 3)

      case $selected in
        "Select")
          # grimblast copysave area
          niri msg action screenshot
          ;;
        "Window")
          # grimblast copysave screen
          niri msg action screenshot-window
          ;;
        "Screen")
          # grimblast copysave output
          niri msg action screenshot-screen
          ;;
      esac
    '';
    executable = true;
  };

}
