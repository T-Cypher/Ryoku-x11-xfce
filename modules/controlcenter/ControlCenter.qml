// Ryoku-style control center. A right-anchored PanelWindow with quick toggles,
// volume / brightness sliders, a media card and power actions. All state is read
// from standard Arch tooling (nmcli, bluetoothctl, redshift, powerprofilesctl,
// wpctl, brightnessctl) so it works without Ryoku's Go daemon.
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import Quickshell.Services.Mpris
import qs.theme
import qs.components

PanelWindow {
    id: cc
    visible: ShellState.controlCenter
    property var scr: Quickshell.screens.length ? Quickshell.screens[0] : null
    screen: scr
    anchors { top: true; right: true }
    margins { top: 58; right: 12 }
    implicitWidth: 360
    implicitHeight: Math.min(720, (scr ? scr.height : 900) - 110)
    focusable: true
    color: "transparent"

    // ---- shared runner -----------------------------------------------------
    Process { id: act }
    function run(args: list<string>): void { act.exec({ command: args }) }

    // ---- toggle state ------------------------------------------------------
    property bool wifiOn: true
    property bool btOn: false
    property bool nightLight: false
    property string powerProfile: "balanced"
    readonly property var profileOrder: ["power-saver", "balanced", "performance"]
    readonly property var profileIcon: ({ "power-saver": "power-profile-power-saver",
        "balanced": "power-profile-balanced", "performance": "power-profile-performance" })

    property var toggles: [
        { icon: "network-wireless", label: "Wi-Fi", get: () => cc.wifiOn,
            flip: () => cc.run(["nmcli", "radio", "wifi", cc.wifiOn ? "off" : "on"]) },
        { icon: "bluetooth", label: "Bluetooth", get: () => cc.btOn,
            flip: () => cc.run(["bluetoothctl", "power", cc.btOn ? "off" : "on"]) },
        { icon: "weather-clear-night", label: "Night Light", get: () => cc.nightLight,
            flip: () => { cc.nightLight = !cc.nightLight; cc.run(["sh", "-c", cc.nightLight ? "redshift -O 4500" : "redshift -x"]) } }
    ]

    function pollStates(): void { if(!wifiProc.running) wifiProc.running=true; if(!btProc.running) btProc.running=true; if(!ppProc.running) ppProc.running=true; if(!volProc.running) volProc.running=true; if(!brightProc.running) brightProc.running=true }
    Timer { interval: 2500; running: cc.visible; repeat: true; onTriggered: cc.pollStates() }

    // ---- volume / brightness ----------------------------------------------
    property real vol: 0
    property bool volMuted: false
    property int bright: 0


    // ---- surface -----------------------------------------------------------
    Rectangle {
        anchors.fill: parent
        radius: Theme.rLg
        color: Theme.panelFill
        border { width: 1; color: Theme.panelBorder }
    }

    GlassSheen { anchors.fill: parent; radius: Theme.rLg }
    Item { anchors.fill: parent; focus: cc.visible; Keys.onPressed: e => { if (e.key === Qt.Key_Escape) ShellState.controlCenter = false } }

    ScrollView {
        anchors.fill: parent
        anchors.margins: 14
        contentWidth: availableWidth
        clip: true

        ColumnLayout {
            spacing: 14
            width: parent.width

            // Header
            RowLayout {
                Layout.fillWidth: true
                Txt { text: "Control Center"; font.pixelSize: 16; font.weight: Font.DemiBold }
                Item { Layout.fillWidth: true }
                IconButton {
                    icon: "window-close"
                    tooltip: "Close"
                    size: 16
                    onClicked: ShellState.controlCenter = false
                }
            }

            // Quick toggles
            GridLayout {
                columns: 3
                Layout.fillWidth: true
                Repeater {
                    model: cc.toggles
                    delegate: Rectangle {
                        required property var modelData
                        Layout.fillWidth: true
                        Layout.preferredHeight: 64
                        radius: Theme.rMd
                        color: modelData.get() ? Theme.surfaceContainerHigh : Theme.surfaceContainer
                        border { width: 1; color: modelData.get() ? Theme.accent : Theme.panelBorder }
                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: modelData.flip()
                        }
                        Column {
                            anchors.centerIn: parent
                            spacing: 4
                            IconImage {
                                anchors.horizontalCenter: parent.horizontalCenter
                                width: 22; height: 22
                                source: Quickshell.iconPath(modelData.icon)
                            }
                            Text {
                                text: modelData.label
                                color: Theme.onSurface
                                font.family: Theme.fontSans
                                font.pixelSize: 11
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }
                    }
                }
            }

            // Power profile (cycling)
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 50
                radius: Theme.rMd
                color: Theme.surfaceContainer
                border { width: 1; color: Theme.panelBorder }
                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 12
                    anchors.rightMargin: 8
                    spacing: 10
                    IconImage {
                        width: 22; height: 22
                        source: Quickshell.iconPath(cc.profileIcon[cc.powerProfile] || "power-profile-balanced")
                    }
                    Column {
                        Txt { text: "Power Profile"; font.pixelSize: 11; color: Theme.onSurfaceVariant }
                        Txt { text: cc.powerProfile; font.pixelSize: 13 }
                    }
                    Item { Layout.fillWidth: true }
                    IconButton {
                        icon: "go-next"
                        tooltip: "Cycle profile"
                        onClicked: {
                            const i = cc.profileOrder.indexOf(cc.powerProfile)
                            const next = cc.profileOrder[(i + 1) % cc.profileOrder.length]
                            cc.run(["powerprofilesctl", "set", next])
                            cc.ppProc.running = true
                        }
                    }
                }
            }

            // Volume
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 6
                RowLayout {
                    IconButton {
                        icon: cc.volMuted ? "audio-volume-muted"
                            : (cc.vol > 0.66 ? "audio-volume-high"
                                : (cc.vol > 0.33 ? "audio-volume-medium" : "audio-volume-low"))
                        onClicked: cc.run(["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"])
                    }
                    Txt { text: cc.volMuted ? "Muted" : Math.round(cc.vol * 100) + "%" }
                    Item { Layout.fillWidth: true }
                }
                HSlider {
                    Layout.fillWidth: true
                    value: cc.vol
                    onMoved: (v) => cc.run(["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", v.toFixed(2)])
                }
            }

            // Brightness
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 6
                RowLayout {
                    IconButton { icon: "display-brightness" }
                    Txt { text: cc.bright + "%" }
                    Item { Layout.fillWidth: true }
                }
                HSlider {
                    Layout.fillWidth: true
                    color: Theme.secondary
                    value: cc.bright / 100
                    onMoved: (v) => cc.run(["brightnessctl", "-q", "set", Math.max(5, Math.round(v * 100)) + "%"])
                }
            }

            // Media card
            MediaCard { }

            // Power actions
            RowLayout {
                Layout.fillWidth: true
                spacing: 8
                PowerAct { icon: "system-lock-screen"; label: "Lock"; cmd: ["xflock4"] }
                PowerAct { icon: "system-log-out"; label: "Logout"; cmd: ["xfce4-session-logout", "--logout"] }
                PowerAct { icon: "system-suspend"; label: "Sleep"; cmd: ["xfce4-session-logout", "--suspend"] }
                PowerAct { icon: "system-reboot"; label: "Reboot"; cmd: ["xfce4-session-logout", "--reboot"] }
                PowerAct { icon: "system-shutdown"; label: "Shut"; cmd: ["xfce4-session-logout", "--halt"] }
            }
        }
    }

    // ---- pollers -----------------------------------------------------------
    Process {
        id: wifiProc; running: true
        command: ["sh", "-c", "nmcli radio wifi"]
        stdout: SplitParser { onRead: d => { cc.wifiOn = d.trim() === "enabled" } }
    }
    Process {
        id: btProc; running: true
        command: ["sh", "-c", "bluetoothctl show 2>/dev/null | grep -qi 'Powered: yes' && echo on || echo off"]
        stdout: SplitParser { onRead: d => { cc.btOn = d.trim() === "on" } }
    }
    Process {
        id: ppProc; running: true
        command: ["powerprofilesctl", "get"]
        stdout: SplitParser { onRead: d => { const v = d.trim(); if (v) cc.powerProfile = v } }
    }
    Process {
        id: volProc; running: true
        command: ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"]
        stdout: SplitParser {
            onRead: d => {
                const m = /Volume:\s*([0-9.]+)/.exec(d)
                cc.volMuted = /MUTED/.test(d)
                if (m) cc.vol = parseFloat(m[1])
            }
        }
    }
    Process {
        id: brightProc; running: true
        command: ["sh", "-c",
            "if command -v brightnessctl >/dev/null; then echo $(brightnessctl g 2>/dev/null) $(brightnessctl m 2>/dev/null); " +
            "elif command -v xbacklight >/dev/null; then echo $(xbacklight -get 2>/dev/null) 100; fi"]
        stdout: SplitParser {
            onRead: d => {
                const p = d.trim().split(/\s+/)
                if (p.length === 2 && Number(p[1]) > 0) cc.bright = Math.round(Number(p[0]) / Number(p[1]) * 100)
            }
        }
    }

    Component.onCompleted: cc.pollStates()
}
