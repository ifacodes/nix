import Quickshell
import Quickshell.Io
import Quickshell.Services.Notifications

ShellRoot {
    NotificationServer {
        id: notifServer
        keepOnReload: true
    }

    // Bar on every screen
    Variants {
        model: Quickshell.screens
        delegate: Bar {}
    }

    // Notification center — single instance, anchored top-right
    NotifCenter {
        id: notifCenter
        notifServer: notifServer
    }

    // Flake update panel — single instance, anchored top-left
    FlakePanel {}

    IpcHandler {
        target: "toggleNotifCenter"
        function toggleNotifCenter() {
            ShellState.toggleNotifCenter()
        }
    }
}
