// Live clock + date. Uses Qt's locale-aware formatting, no shelling out.
import QtQuick
import qs.theme
import qs.components

Item {
    id: root
    implicitWidth: col.implicitWidth
    implicitHeight: col.implicitHeight

    property var now: new Date()

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: root.now = new Date()
    }

    Column {
        id: col
        spacing: 0
        Txt {
            text: Qt.formatTime(root.now, "hh:mm")
            font.family: Theme.fontMono
            font.pixelSize: 15
            font.weight: Font.DemiBold
        }
        Txt {
            text: Qt.formatDate(root.now, "ddd d MMM").toUpperCase()
            font.pixelSize: 9
            color: Theme.onSurfaceVariant
            font.letterSpacing: 1
        }
    }
    MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: ShellState.toggleCalendar() }
}
