// Centered power menu using XFCE's own session commands (no root needed).
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import qs.theme
import qs.components

PanelWindow {
    id: pm
    visible: ShellState.powerMenu
    property var scr: Quickshell.screens.length ? Quickshell.screens[0] : null
    screen: scr
    anchors { top: true; left: true; right: true }
    margins {
        top: scr ? Math.max(20, Math.round((scr.height - 130) / 2)) : 100
        left: scr ? Math.max(10, Math.round((scr.width - 400) / 2)) : 100
        right: scr ? Math.max(10, Math.round((scr.width - 400) / 2)) : 100
    }
    implicitHeight: 130
    focusable: true
    color: "transparent"

    Process { id: act }
    function run(args: list<string>): void { act.exec({ command: args }) }

    Rectangle {
        anchors.fill: parent
        radius: Theme.rLg
        color: Theme.panelFill
        border { width: 1; color: Theme.panelBorder }
    }

    GlassSheen { anchors.fill: parent; radius: Theme.rLg }
    Item { anchors.fill: parent; focus: pm.visible; Keys.onPressed: e => { if (e.key === Qt.Key_Escape) ShellState.powerMenu = false } }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 10
        Txt { text: "Power"; font.pixelSize: 14; font.weight: Font.DemiBold }
        RowLayout {
            Layout.fillWidth: true
            spacing: 10
            PButton { icon: "system-lock-screen"; label: "Lock";   cmd: ["xflock4"] }
            PButton { icon: "system-log-out";     label: "Logout"; cmd: ["xfce4-session-logout", "--logout"] }
            PButton { icon: "system-suspend";     label: "Sleep";  cmd: ["xfce4-session-logout", "--suspend"] }
            PButton { icon: "system-reboot";      label: "Reboot"; cmd: ["xfce4-session-logout", "--reboot"] }
            PButton { icon: "system-shutdown";    label: "Shut";   cmd: ["xfce4-session-logout", "--halt"] }
        }
    }

    // Inline power button (kept local to avoid cross-module dependencies).
    component PButton: Item {
        property string icon: ""
        property string label: ""
        property list<string> cmd: []
        implicitWidth: 64
        implicitHeight: 64
        Rectangle {
            anchors.fill: parent
            radius: Theme.rMd
            color: ma.containsMouse ? Theme.surfaceContainerHigh : Theme.surfaceContainer
            border { width: 1; color: Theme.panelBorder }
        }
        Column {
            anchors.centerIn: parent
            spacing: 4
            IconImage {
                anchors.horizontalCenter: parent.horizontalCenter
                width: 24
                height: 24
                source: Quickshell.iconPath(icon)
            }
            Text {
                text: label
                color: Theme.onSurface
                font.family: Theme.fontSans
                font.pixelSize: 11
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
        MouseArea {
            id: ma
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: pm.run(cmd)
        }
    }
}
