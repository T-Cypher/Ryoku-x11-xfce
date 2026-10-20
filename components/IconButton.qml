// Pill-style icon button used across the bar and panels. Hover/active highlight
// matches Ryoku's monochrome "sumi" rail. Uses freedesktop icon names resolved
// through Quickshell's icon theme lookup.
import QtQuick
import Quickshell
import Quickshell.Widgets
import qs.theme

Item {
    id: root
    property string icon: ""
    property string tooltip: ""
    property int size: 18
    property bool active: false
    property bool highlightOnHover: true
    signal clicked()

    implicitWidth: size + 16
    implicitHeight: size + 16

    Rectangle {
        anchors.fill: parent
        radius: Theme.rXs
        color: ((mouse.containsMouse && root.highlightOnHover) || root.active)
            ? Theme.surfaceContainerHigh : "transparent"
    }

    IconImage {
        anchors.centerIn: parent
        width: root.size
        height: root.size
        source: root.icon ? Quickshell.iconPath(root.icon) : ""
        // Falls back to nothing if the name is missing from the theme.
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }

    // Lightweight tooltip (no QtQuick.Controls dependency).
    Item {
        id: tip
        visible: mouse.containsMouse && root.tooltip !== ""
        x: Math.round((root.width - ttxt.width - 12) / 2)
        y: root.height + 5
        height: ttxt.height + 8
        width: ttxt.width + 12
        Rectangle {
            anchors.fill: parent
            radius: 6
            color: Theme.surfaceContainerHighest
            border { width: 1; color: Theme.panelBorder }
        }
        Text {
            id: ttxt
            x: 6
            y: 4
            text: root.tooltip
            color: Theme.onSurface
            font.family: Theme.fontSans
            font.pixelSize: 11
        }
    }
}
