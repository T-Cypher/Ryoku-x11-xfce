// The Ryoku-style pill bar. On X11 this is a Quickshell PanelWindow, which maps
// to an X11 dock with _NET_WM_STRUT_PARTIAL so xfwm4 reserves the top strip.
// The capsule look comes from a rounded, translucent fill on a transparent window.
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import qs.theme
import qs.components

PanelWindow {
    id: bar
    required property var modelData
    screen: modelData

    anchors { top: true; left: true; right: true }
    margins { top: 8; left: 10; right: 10 }
    implicitHeight: 46
    color: "transparent"

    Rectangle {
        anchors.fill: parent
        radius: Theme.rMd
        color: Theme.barFill
        opacity: Theme.barOpacity
        border { width: 1; color: Theme.panelBorder }
    }

    GlassSheen { anchors.fill: parent; radius: Theme.rMd }

    RowLayout {
        anchors.fill: parent
        anchors.margins: 9
        spacing: 6

        // Left: launcher, workspaces, active window
        IconButton {
            icon: "archlinux"
            tooltip: "Applications"
            onClicked: ShellState.toggleLauncher()
        }
        WorkspacesWidget { id: workspaces }
        Txt {
            text: workspaces.activeWindow
            elide: Text.ElideRight
            Layout.maximumWidth: 280
            color: Theme.onSurfaceVariant
            visible: text !== ""
        }

        Item { Layout.fillWidth: true }

        // Center
        ClockWidget {}

        Item { Layout.fillWidth: true }

        // Right: media, status, tray, menus
        MediaWidget {}
        NetworkWidget {}
        VolumeWidget {}
        BrightnessWidget {}
        BatteryWidget {}
        TrayWidget {}
        IconButton {
            icon: "preferences-system"
            tooltip: "Control Center"
            onClicked: ShellState.toggleControlCenter()
        }
        IconButton {
            icon: "system-shutdown-symbolic"
            tooltip: "Power"
            onClicked: ShellState.togglePowerMenu()
        }
    }
}
