// Output volume via WirePlumber (wpctl). Works with both PipeWire and
// pipewire-pulse. Click mutes, the control center exposes a slider.
import QtQuick
import Quickshell
import Quickshell.Io
import qs.theme
import qs.components

Item {
    id: root
    implicitWidth: volRow.implicitWidth
    implicitHeight: volRow.implicitHeight

    property real volume: 0      // 0..1
    property bool muted: false
    property bool available: false

    function refresh(): void { if (!volProc.running) volProc.running = true }
    function setVolume(v: real): void {
        v = Math.max(0, Math.min(1, v))
        action.exec({ command: ["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", v.toFixed(2)] }); ShellState.showOsd("volume", v)
        rt.restart()
    }
    function toggleMute(): void {
        action.exec({ command: ["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"] }); ShellState.showOsd("volume", root.volume)
        rt.restart()
    }

    Row {
        id: volRow
        spacing: 6
        IconButton {
            icon: root.muted ? "audio-volume-muted"
                : (root.volume > 0.66 ? "audio-volume-high"
                    : (root.volume > 0.33 ? "audio-volume-medium" : "audio-volume-low"))
            tooltip: root.muted ? "Unmute" : "Mute"
            onClicked: root.toggleMute()
        }
        Txt {
            text: root.available ? Math.round(root.volume * 100) + "%" : "—"
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    Process {
        id: volProc
        running: true
        command: ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"]
        stdout: SplitParser {
            onRead: data => {
                const m = /Volume:\s*([0-9.]+)/.exec(data)
                const muted = /MUTED/.test(data)
                if (m) root.volume = parseFloat(m[1])
                root.muted = muted
                root.available = true
            }
        }
    }
    Process { id: action }
    Timer { id: rt; interval: 250; onTriggered: root.refresh() }
    Timer { interval: 2000; running: true; repeat: true; onTriggered: root.refresh() }
    Component.onCompleted: root.refresh()
}
