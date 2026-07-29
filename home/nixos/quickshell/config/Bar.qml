import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Services.SystemTray
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

PanelWindow {
    id: root
    required property var modelData
    screen: modelData

    anchors {
        top: true
        left: true
        right: true
    }

    readonly property int barMargin: 18
    implicitHeight: leftPill.implicitHeight + barMargin * 2
    color: "transparent"

    WlrLayershell.namespace: "quickshell-bar"
    WlrLayershell.layer: WlrLayer.Top

    // ── Data: RAM ──────────────────────────────────────────────────────
    property string ramText: "󰘚 —"

    FileView {
        id: meminfoFile
        path: "/proc/meminfo"
        blockLoading: true
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            var lines = meminfoFile.text().split("\n")
            var total = 0, available = 0
            for (var i = 0; i < lines.length; i++) {
                var m = lines[i].match(/^MemTotal:\s+(\d+)/)
                if (m) total = parseInt(m[1])
                m = lines[i].match(/^MemAvailable:\s+(\d+)/)
                if (m) available = parseInt(m[1])
            }
            if (total > 0) {
                var usedGb = ((total - available) / 1048576).toFixed(1)
                root.ramText = "󰘚 " + usedGb + "GB"
            }
        }
    }

    // ── Data: Disk ─────────────────────────────────────────────────────
    property string diskText: "󰉉 —"

    Process {
        id: diskProc
        stdout: SplitParser {
            onRead: data => {
                var cols = data.trim().split(/\s+/)
                if (cols.length >= 5 && cols[0] !== "Filesystem") {
                    root.diskText = "󰉉 " + cols[4]
                }
            }
        }
    }

    Timer {
        interval: 30000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: diskProc.exec(["df", "/"])
    }

    // ── Data: Volume ───────────────────────────────────────────────────
    property string volText: " —"

    Process {
        id: volProc
        stdout: SplitParser {
            onRead: data => {
                var m = data.match(/Volume:\s+([\d.]+)(\s+\[MUTED\])?/)
                if (m) {
                    var pct = Math.round(parseFloat(m[1]) * 100)
                    root.volText = (m[2] ? "󰖁 " : " ") + pct + "%"
                }
            }
        }
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: volProc.exec(["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"])
    }

    // ── Data: Network ──────────────────────────────────────────────────
    property string netText: "󰤮 "

    Process {
        id: netProc
        stdout: SplitParser {
            onRead: data => {
                var line = data.trim()
                if (line === "") {
                    root.netText = "󰤮 "
                    return
                }
                if (line.match(/^wl/)) {
                    root.netText = " "
                } else {
                    root.netText = "󰈀 "
                }
            }
        }
    }

    Timer {
        interval: 10000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: netProc.exec([
            "sh", "-c",
            "ip -br link show | awk '$2==\"UP\" && $1!=\"lo\" {print $1; exit}'"
        ])
    }

    // ── Data: Flake age ────────────────────────────────────────────────
    property int flakeAgeDays: -1

    Process {
        id: flakeAgeProc
        stdout: SplitParser {
            onRead: data => {
                var age = parseInt(data.trim())
                if (!isNaN(age)) root.flakeAgeDays = age
            }
        }
    }

    Timer {
        interval: 3600000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: flakeAgeProc.exec(["bash", "-c",
            "echo $(( ( $(date +%s) - $(stat -c %Y /home/ifa/projects/nixos-config/flake.lock) ) / 86400 ))"])
    }

    // ── Workspace tracking ─────────────────────────────────────────────
    property var thisMonitor: Hyprland.monitorFor(root.screen)
    property int activeWsId: {
        var mon = root.thisMonitor
        return (mon && mon.activeWorkspace) ? mon.activeWorkspace.id : -1
    }

    // ── Clock ──────────────────────────────────────────────────────────
    property string clockText: "--:-- --"

    Timer {
        interval: 10000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            var d = new Date()
            var h = d.getHours()
            var m = d.getMinutes()
            var ampm = h >= 12 ? "PM" : "AM"
            h = h % 12
            if (h === 0) h = 12
            root.clockText = h + ":" + (m < 10 ? "0" : "") + m + " " + ampm
        }
    }

    // ── Layout ─────────────────────────────────────────────────────────
    Item {
        anchors {
            fill: parent
            topMargin: root.barMargin
            bottomMargin: root.barMargin
        }

        // Left: RAM  Disk  |  Clock
        Pill {
            id: leftPill
            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
                leftMargin: 28
            }
            spacing: 20

            Text { text: root.ramText;  color: Colors.text;   font.pointSize: 22; font.family: Colors.fontMono }
            Text { text: root.diskText; color: Colors.text;   font.pointSize: 22; font.family: Colors.fontMono }
            Text { text: "|";           color: Colors.subtle; font.pointSize: 22 }
            Text { text: root.clockText; color: Colors.text;  font.pointSize: 22; font.family: Colors.fontMono }
        }

        // Center: workspaces 1–9
        Pill {
            anchors.centerIn: parent
            height: leftPill.implicitHeight
            spacing: 8

            Repeater {
                model: [1, 2, 3, 4, 5, 6, 7, 8, 9]
                delegate: Item {
                    required property int modelData

                    property bool wsExists: {
                        for (var i = 0; i < Hyprland.workspaces.length; i++) {
                            if (Hyprland.workspaces[i].id === modelData) return true
                        }
                        return false
                    }
                    property bool wsActive: root.activeWsId === modelData

                    width: 44
                    implicitHeight: wsLabel.implicitHeight

                    Text {
                        id: wsLabel
                        anchors.centerIn: parent
                        text: parent.wsActive ? "✦" : "✧"
                        font.pointSize: 22
                        font.family: Colors.fontMono
                        color: parent.wsActive  ? Colors.accent
                             : parent.wsExists  ? Colors.text
                             :                    Colors.subtle
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: Hyprland.dispatch("workspace " + parent.modelData)
                    }
                }
            }
        }

        // Right: Tray  |  Volume  Network  Bell
        Pill {
            height: leftPill.implicitHeight
            anchors {
                right: parent.right
                verticalCenter: parent.verticalCenter
                rightMargin: 28
            }
            spacing: 20

            Repeater {
                model: SystemTray.items
                delegate: Item {
                    id: trayItem
                    required property var modelData
                    width: 32
                    height: 32

                    Image {
                        anchors.fill: parent
                        source: {
                            var icon = trayItem.modelData.icon
                            if (icon.startsWith("image://") || icon.startsWith("/"))
                                return icon
                            return Quickshell.iconPath(icon)
                        }
                        sourceSize.width: 32
                        sourceSize.height: 32
                        smooth: true
                        mipmap: true
                    }

                    MouseArea {
                        anchors.fill: parent
                        acceptedButtons: Qt.LeftButton | Qt.RightButton
                        onClicked: trayItem.modelData.activate()
                    }
                }
            }

            Text { text: "|";           color: Colors.subtle; font.pointSize: 22 }
            Text { text: root.volText;  color: Colors.text;   font.pointSize: 22; font.family: Colors.fontMono }
            Text { text: root.netText;  color: Colors.text;   font.pointSize: 22 }

            // Flake age indicator
            Item {
                width: flakeLabel.implicitWidth + 8
                height: 48

                Text {
                    id: flakeLabel
                    anchors.centerIn: parent
                    text: root.flakeAgeDays >= 0 ? "❄ " + root.flakeAgeDays + "d" : "❄"
                    font.pointSize: 22
                    font.family: Colors.fontMono
                    color: root.flakeAgeDays > 30 ? Colors.error
                         : root.flakeAgeDays > 14 ? Colors.accent
                         : Colors.text
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: ShellState.toggleFlakePanel()
                }
            }

            // Notification bell
            Item {
                width: 56
                height: 48

                Text {
                    anchors.centerIn: parent
                    text: "󰂚"
                    font.pointSize: 22
                    color: Colors.text
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: ShellState.toggleNotifCenter()
                }
            }
        }
    }
}
