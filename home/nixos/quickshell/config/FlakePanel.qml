import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

PanelWindow {
    id: root

    readonly property string flakePath: "/home/ifa/projects/nixos-config"
    property bool open: ShellState.flakePanelOpen

    anchors {
        top: true
        left: true
    }

    implicitWidth: 440
    implicitHeight: panel.implicitHeight
    color: "transparent"

    WlrLayershell.namespace: "quickshell-flake-panel"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

    mask: Region { item: revealClip }
    visible: open || closeTimer.running

    onOpenChanged: {
        if (!open) closeTimer.restart()
        else readLock()
    }

    Timer { id: closeTimer; interval: 220; repeat: false }

    HyprlandFocusGrab {
        windows: [root]
        active: root.open
        onCleared: ShellState.closeFlakePanel()
    }

    // ── State ───────────────────────────────────────────────────────────
    ListModel { id: inputModel }
    property string updateOutput: ""
    property bool updating: false

    // ── Read flake.lock ─────────────────────────────────────────────────
    Process {
        id: lockProc
        property string buf: ""
        stdout: SplitParser { onRead: data => lockProc.buf += data + "\n" }
        onRunningChanged: {
            if (!running) {
                parseLock(lockProc.buf)
                lockProc.buf = ""
            }
        }
    }

    function readLock() {
        lockProc.buf = ""
        lockProc.exec(["cat", flakePath + "/flake.lock"])
    }

    function parseLock(text) {
        inputModel.clear()
        try {
            var lock = JSON.parse(text)
            var rootInputs = lock.nodes.root.inputs || {}
            var now = Date.now() / 1000
            var result = []
            for (var name in rootInputs) {
                var ref = rootInputs[name]
                // Follows are arrays — skip them
                if (Array.isArray(ref)) continue
                var node = lock.nodes[ref]
                if (!node || !node.locked) continue
                // Skip local path inputs
                if (node.locked.type === "path") continue
                result.push({
                    inputName: name,
                    inputAge: Math.floor((now - node.locked.lastModified) / 86400),
                    inputRev: node.locked.rev ? node.locked.rev.substring(0, 8) : "—"
                })
            }
            result.sort((a, b) => b.inputAge - a.inputAge)
            for (var i = 0; i < result.length; i++)
                inputModel.append(result[i])
        } catch(e) {
            inputModel.append({ inputName: "Error: " + e, inputAge: -1, inputRev: "" })
        }
    }

    // ── nix flake update ────────────────────────────────────────────────
    Process {
        id: updateProc
        property string buf: ""
        stdout: SplitParser { onRead: data => updateProc.buf += data + "\n" }
        onRunningChanged: {
            if (!running) {
                root.updateOutput = updateProc.buf.trim() || "(no output)"
                updateProc.buf = ""
                root.updating = false
                root.readLock()
            }
        }
    }

    function runUpdate() {
        updating = true
        updateOutput = "running…"
        updateProc.buf = ""
        updateProc.exec(["bash", "-c", "cd " + flakePath + " && nix flake update 2>&1"])
    }

    // ── UI ──────────────────────────────────────────────────────────────
    Item {
        id: revealClip
        anchors { top: parent.top; left: parent.left }
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
                    margins: 16
                }
                spacing: 8

                // Header
                RowLayout {
                    Layout.fillWidth: true
                    Text {
                        text: "❄  Flake Inputs"
                        color: Colors.text
                        font.pointSize: 20
                        font.bold: true
                        Layout.fillWidth: true
                    }
                    Rectangle {
                        width: btnText.implicitWidth + 20
                        height: 32
                        radius: 8
                        color: root.updating ? Colors.surface : Colors.accent
                        Text {
                            id: btnText
                            anchors.centerIn: parent
                            text: root.updating ? "updating…" : "update"
                            color: Colors.base00
                            font.pointSize: 15
                            font.family: Colors.fontMono
                        }
                        MouseArea {
                            anchors.fill: parent
                            enabled: !root.updating
                            onClicked: root.runUpdate()
                        }
                    }
                }

                Rectangle { Layout.fillWidth: true; height: 1; color: Colors.subtle; opacity: 0.25 }

                // Input rows: name | short rev | age in days
                Repeater {
                    model: inputModel
                    delegate: RowLayout {
                        required property string inputName
                        required property int inputAge
                        required property string inputRev
                        Layout.fillWidth: true
                        spacing: 10

                        Text {
                            text: inputName
                            color: Colors.text
                            font.pointSize: 16
                            font.family: Colors.fontMono
                            Layout.fillWidth: true
                        }
                        Text {
                            text: inputRev
                            color: Colors.subtle
                            font.pointSize: 14
                            font.family: Colors.fontMono
                        }
                        Text {
                            text: inputAge >= 0 ? inputAge + "d" : "—"
                            color: inputAge > 30 ? Colors.error
                                 : inputAge > 14 ? Colors.accent
                                 : Colors.text
                            font.pointSize: 15
                            font.family: Colors.fontMono
                            width: 42
                            horizontalAlignment: Text.AlignRight
                        }
                    }
                }

                // Update output
                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: Colors.subtle
                    opacity: 0.25
                    visible: root.updateOutput.length > 0
                }
                Text {
                    visible: root.updateOutput.length > 0
                    Layout.fillWidth: true
                    text: root.updateOutput
                    color: Colors.subtle
                    font.pointSize: 13
                    font.family: Colors.fontMono
                    wrapMode: Text.Wrap
                }
            }
        }
    }
}
