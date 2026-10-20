// System tray (StatusNotifier) rendered with Quickshell's SystemTray service.
// Left-click activates the item. Hidden when empty.
import QtQuick
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import qs.theme

Item {
    id: root
    implicitHeight: 24
    implicitWidth: trayRow.implicitWidth
    visible: SystemTray.items.values.length > 0

    Row {
        id: trayRow
        spacing: 4
        Repeater {
            model: SystemTray.items
            delegate: Item {
                required property var modelData
                width: 20
                height: 20
                IconImage {
                    anchors.centerIn: parent
                    width: 18
                    height: 18
                    source: modelData.icon
                }
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: modelData.activate()
                }
            }
        }
    }
}
