{...}:

{
  home.file.".local/bin/power-menu" = {
    text = ''
      #!/bin/sh

      # Main power menu options
      selected=$(echo -e "  Lock\n󰏤  Suspend\n⏾  Sleep\n󰍃  Logout\n󰜉  Reboot\n  Shutdown" | \
        fuzzel --dmenu \
        --prompt "" \
        --width 30 \
        --lines 6 \
        --hide-prompt)

      # Confirmation dialog for destructive actions
      confirm() {
        action=$1
        echo -e "  Yes\n  No" | \
          fuzzel --dmenu \
          --prompt "" \
          --width 25 \
          --lines 2 \
          --hide-prompt
        }

      case $selected in
        *Lock*)
          sleep 0.3 && QS_THEME=columbina qs -p ~/.config/quickshell/meowshell/test.qml
          ;;
        *Suspend*)
          if [ "$(confirm 'Suspend')" = "$(echo -e '  Yes')" ]; then
            systemctl suspend
          fi
          ;;
        *Sleep*)
          if [ "$(confirm 'Sleep')" = "$(echo -e '  Yes')" ]; then
            systemctl hybrid-sleep
          fi
          ;;
        *Logout*)
          if [ "$(confirm 'Logout')" = "$(echo -e '  Yes')" ]; then
            hyprshutdown
          fi
          ;;
        *Reboot*)
          if [ "$(confirm 'Reboot')" = "$(echo -e '  Yes')" ]; then
            hyprshutdown --post-cmd 'reboot'
          fi
          ;;
        *Shutdown*)
          if [ "$(confirm 'Shutdown')" = "$(echo -e '  Yes')" ]; then
            hyprshutdown --post-cmd 'shutdown -P 0'
          fi
          ;;
      esac
    '';
    executable = true;
  };
}
