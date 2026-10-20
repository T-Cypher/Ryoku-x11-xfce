// A square power-action button (Lock / Logout / Sleep / Reboot / Shut). Runs the
// given command through XFCE's own session tools so no root is required.
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import qs.theme
import qs.components

Item {
    id: root
    property string icon: ""
    property string label: ""
    property list<string> cmd: []

    implicitWidth: 58
    implicitHeight: 58

    Rectangle {
        anchors.fill: parent
        radius: Theme.rMd
        color: ma.containsMouse ? Theme.surfaceContainerHigh : Theme.surfaceContainer
        border { width: 1; color: Theme.panelBorder }
    }

    Column {
        anchors.centerIn: parent
        spacing: 3
        IconImage {
            anchors.horizontalCenter: parent.horizontalCenter
            width: 20
            height: 20
            source: Quickshell.iconPath(root.icon)
        }
        Text {
            text: root.label
            color: Theme.onSurface
            font.family: Theme.fontSans
            font.pixelSize: 10
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    MouseArea {
        id: ma
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: p.exec({ command: root.cmd })
    }

    Process { id: p }
}
