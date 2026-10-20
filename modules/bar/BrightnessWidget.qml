// Screen brightness via brightnessctl (falls back to xbacklight if present).
import QtQuick
import Quickshell
import Quickshell.Io
import qs.theme
import qs.components

Item {
    id: root
    implicitWidth: brightRow.implicitWidth
    implicitHeight: brightRow.implicitHeight

    property int percent: 0
    property bool available: false

    function refresh(): void { if (!proc.running) proc.running = true }
    function setPercent(p: int): void {
        p = Math.max(5, Math.min(100, p))
        action.exec({ command: ["brightnessctl", "-q", "set", p + "%"] }); ShellState.showOsd("brightness", p/100)
        rt.restart()
    }

    Row {
        id: brightRow
        spacing: 6
        IconButton {
            icon: "display-brightness"
            tooltip: "Brightness"
            onClicked: root.setPercent(root.percent + 10)
        }
        Txt {
            text: root.available ? root.percent + "%" : "—"
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    Process {
        id: proc
        running: true
        command: ["sh", "-c",
            "if command -v brightnessctl >/dev/null; then echo $(brightnessctl g 2>/dev/null) $(brightnessctl m 2>/dev/null); " +
            "elif command -v xbacklight >/dev/null; then echo $(xbacklight -get 2>/dev/null) 100; fi"]
        stdout: SplitParser {
            onRead: data => {
                const parts = data.trim().split(/\s+/)
                if (parts.length === 2 && Number(parts[1]) > 0) {
                    root.percent = Math.round(Number(parts[0]) / Number(parts[1]) * 100)
                    root.available = true
                } else {
                    root.available = false
                }
            }
        }
    }
    Process { id: action }
    Timer { id: rt; interval: 250; onTriggered: root.refresh() }
    Timer { interval: 3000; running: true; repeat: true; onTriggered: root.refresh() }
    Component.onCompleted: root.refresh()
}
