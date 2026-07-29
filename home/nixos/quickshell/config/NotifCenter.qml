import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Services.Notifications
import Quickshell.Services.Mpris
import QtQuick
import QtQuick.Layouts

PanelWindow {
    id: root

    required property NotificationServer notifServer

    property bool open: ShellState.notifCenterOpen

    anchors {
        top: true
        right: true
    }

    implicitWidth: 400
    implicitHeight: panel.implicitHeight
    color: "transparent"

    WlrLayershell.namespace: "quickshell-notif-center"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

    // Limit pointer input to the visible panel area only
    mask: Region { item: revealClip }

    // Keep the wl_surface alive during the close animation
    visible: open || closeTimer.running

    onOpenChanged: {
        if (!open) closeTimer.restart()
    }

    Timer {
        id: closeTimer
        interval: 220
        repeat: false
    }

    // Grab all input while open; clicking outside consumes the click and closes the panel
    HyprlandFocusGrab {
        windows: [root]
        active: root.open
        onCleared: ShellState.closeNotifCenter()
    }

    // DND state (local; no built-in property on NotificationServer)
    property bool dnd: false

    // Clip container — grows downward from the bar
    Item {
        id: revealClip
        anchors.top: parent.top
        anchors.right: parent.right
        width: root.implicitWidth
        height: root.open ? panel.implicitHeight : 0
        clip: true
        layer.enabled: true

        Behavior on height {
            NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
        }

        Rectangle {
            id: panel
            width: parent.width
            implicitHeight: col.implicitHeight + 24
            color: Colors.bgPanel
            radius: 12

            ColumnLayout {
                id: col
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                    margins: 12
                }
                spacing: 8

                // ── Header ────────────────────────────────────────────────
                RowLayout {
                    Layout.fillWidth: true

                    Text {
                        text: "Notifications"
                        color: Colors.text
                        font.pointSize: Colors.fontSizePt + 1
                        font.family: Colors.fontSans
                        font.bold: true
                        Layout.fillWidth: true
                    }

                    // DND toggle
                    Rectangle {
                        width: 80
                        height: 26
                        radius: 4
                        color: root.dnd ? Colors.accent : Colors.surface

                        Text {
                            anchors.centerIn: parent
                            text: root.dnd ? "󰂛 DND" : "󰂚 DND"
                            color: root.dnd ? Colors.base00 : Colors.text
                            font.pointSize: Colors.fontSizePt - 1
                            font.family: Colors.fontSans
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: root.dnd = !root.dnd
                        }
                    }

                    // Clear all
                    Rectangle {
                        width: 64
                        height: 26
                        radius: 4
                        color: Colors.surface

                        Text {
                            anchors.centerIn: parent
                            text: "Clear all"
                            color: Colors.text
                            font.pointSize: Colors.fontSizePt - 1
                            font.family: Colors.fontSans
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                var notifs = root.notifServer.trackedNotifications
                                for (var i = notifs.length - 1; i >= 0; i--) {
                                    notifs[i].dismiss()
                                }
                            }
                        }
                    }
                }

                Rectangle { Layout.fillWidth: true; height: 1; color: Colors.subtle; opacity: 0.4 }

                // ── MPRIS ─────────────────────────────────────────────────
                Repeater {
                    model: Mpris.players
                    delegate: Rectangle {
                        required property MprisPlayer modelData
                        Layout.fillWidth: true
                        height: mprisCol.implicitHeight + 16
                        color: Colors.surface
                        radius: 6

                        ColumnLayout {
                            id: mprisCol
                            anchors {
                                left: parent.left
                                right: parent.right
                                verticalCenter: parent.verticalCenter
                                margins: 10
                            }
                            spacing: 6

                            Text {
                                text: parent.parent.modelData.trackTitle || "Unknown"
                                color: Colors.text
                                font.pointSize: Colors.fontSizePt
                                font.family: Colors.fontSans
                                font.bold: true
                                elide: Text.ElideRight
                                Layout.fillWidth: true
                            }
                            Text {
                                text: parent.parent.modelData.trackArtist || ""
                                color: Colors.subtle
                                font.pointSize: Colors.fontSizePt - 1
                                font.family: Colors.fontSans
                                elide: Text.ElideRight
                                Layout.fillWidth: true
                                visible: text !== ""
                            }

                            RowLayout {
                                spacing: 16
                                Layout.alignment: Qt.AlignHCenter

                                Text {
                                    text: "󰒮"
                                    font.pixelSize: 18
                                    color: Colors.text
                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: mprisCol.parent.parent.modelData.previous()
                                    }
                                }
                                Text {
                                    text: mprisCol.parent.parent.modelData.playbackState === MprisPlaybackShellState.Playing
                                          ? "󰏤" : "󰐊"
                                    font.pixelSize: 20
                                    color: Colors.accent
                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: mprisCol.parent.parent.modelData.togglePlaying()
                                    }
                                }
                                Text {
                                    text: "󰒭"
                                    font.pixelSize: 18
                                    color: Colors.text
                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: mprisCol.parent.parent.modelData.next()
                                    }
                                }
                            }
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: Colors.subtle
                    opacity: 0.4
                    visible: Mpris.players.length > 0
                }

                // ── Notification list ─────────────────────────────────────
                ListView {
                    id: notifList
                    Layout.fillWidth: true
                    implicitHeight: contentHeight
                    clip: true
                    spacing: 6
                    model: root.notifServer.trackedNotifications

                    delegate: Rectangle {
                        required property Notification modelData
                        width: notifList.width
                        height: notifRow.implicitHeight + 16
                        color: Colors.surface
                        radius: 6

                        RowLayout {
                            id: notifRow
                            anchors {
                                left: parent.left
                                right: parent.right
                                verticalCenter: parent.verticalCenter
                                leftMargin: 10
                                rightMargin: 10
                            }
                            spacing: 8

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 2

                                Text {
                                    text: parent.parent.parent.modelData.appName
                                    color: Colors.subtle
                                    font.pointSize: Colors.fontSizePt - 2
                                    font.family: Colors.fontSans
                                    elide: Text.ElideRight
                                    Layout.fillWidth: true
                                }
                                Text {
                                    text: parent.parent.parent.modelData.summary
                                    color: Colors.text
                                    font.pointSize: Colors.fontSizePt
                                    font.family: Colors.fontSans
                                    font.bold: true
                                    elide: Text.ElideRight
                                    Layout.fillWidth: true
                                    visible: text !== ""
                                }
                                Text {
                                    text: parent.parent.parent.modelData.body
                                    color: Colors.text
                                    font.pointSize: Colors.fontSizePt - 1
                                    font.family: Colors.fontSans
                                    wrapMode: Text.WordWrap
                                    Layout.fillWidth: true
                                    visible: text !== ""
                                }
                            }

                            // Close button
                            Text {
                                text: "󰅖"
                                font.pixelSize: 14
                                color: Colors.subtle
                                MouseArea {
                                    anchors.fill: parent
                                    anchors.margins: -4
                                    onClicked: parent.parent.parent.parent.modelData.dismiss()
                                }
                            }
                        }
                    }

                    // Empty state
                    Text {
                        anchors.centerIn: parent
                        text: "No notifications"
                        color: Colors.subtle
                        font.pointSize: Colors.fontSizePt
                        font.family: Colors.fontSans
                        visible: notifList.count === 0
                    }
                }
            }
        }
    }
}
