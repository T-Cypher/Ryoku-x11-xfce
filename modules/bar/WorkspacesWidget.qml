// xfwm4 workspace pips + active-window title.
// xfwm4 exposes workspaces over EWMH; we read them with wmctrl and switch with
// `wmctrl -s <index>`. Active window name comes from xdotool.
import QtQuick
import Quickshell
import Quickshell.Io
import qs.theme
import qs.components

Item {
    id: root
    implicitWidth: wsRow.implicitWidth
    implicitHeight: wsRow.implicitHeight

    property int count: 1
    property int current: 0
    property string activeWindow: ""

    function refresh(): void { if (!proc.running) proc.running = true; if (!winProc.running) winProc.running = true }
    function goTo(i: int): void {
        action.exec({ command: ["wmctrl", "-s", String(i)] })
        refresh()
    }

    Row {
        id: wsRow
        spacing: 5
        Repeater {
            model: root.count
            delegate: Rectangle {
                required property int index
                width: 9
                height: 9
                radius: 4
                color: index === root.current ? Theme.accent : Theme.outline
                opacity: index === root.current ? 1 : 0.55
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.goTo(index)
                }
            }
        }
    }

    Process {
        id: proc
        running: true
        command: ["sh", "-c", "wmctrl -d | wc -l; wmctrl -d | awk '/\\*/{print NR-1}'"]
        stdout: StdioCollector {
            onStreamFinished: {
                const lines = (this.text || "").trim().split("\n")
                    .map(s => s.trim()).filter(s => s !== "")
                if (lines.length >= 1) {
                    const c = parseInt(lines[0], 10)
                    if (!isNaN(c) && c > 0) root.count = c
                }
                if (lines.length >= 2) {
                    const cur = parseInt(lines[1], 10)
                    if (!isNaN(cur)) root.current = cur
                }
            }
        }
    }
    Process {
        id: winProc
        running: true
        command: ["sh", "-c", "xdotool getactivewindow getwindowname 2>/dev/null || true"]
        stdout: StdioCollector { onStreamFinished: { root.activeWindow = (this.text || "").trim() } }
    }
    Process { id: action }

    Timer {
        interval: 700
        running: true
        repeat: true
        onTriggered: root.refresh()
    }
    Component.onCompleted: root.refresh()
}
