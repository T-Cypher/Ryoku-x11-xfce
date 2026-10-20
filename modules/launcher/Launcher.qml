// Ryoku-style application launcher. Reads the system .desktop entries through
// Quickshell's DesktopEntries singleton, filters as you type, and launches with a
// click or Enter. Fully keyboard driven (arrows / Enter / Esc).
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import qs.theme
import qs.components

PanelWindow {
    id: launcher
    visible: ShellState.launcher
    property var scr: Quickshell.screens.length ? Quickshell.screens[0] : null
    screen: scr
    anchors { top: true; left: true; right: true }
    margins {
        top: scr ? Math.max(20, Math.round((scr.height - 540) / 2)) : 100
        left: scr ? Math.max(10, Math.round((scr.width - 640) / 2)) : 100
        right: scr ? Math.max(10, Math.round((scr.width - 640) / 2)) : 100
    }
    implicitHeight: 540
    focusable: true
    color: "transparent"

    property string query: ""
    readonly property int count: appModel.values.length

    onVisibleChanged: {
        if (visible) {
            launcher.query = ""
            search.text = ""
            grid.currentIndex = 0
            search.forceActiveFocus()
        }
    }

    function launch(i: int): void {
        const e = appModel.values[i]
        if (e) e.execute()
        ShellState.launcher = false
    }

    ScriptModel {
        id: appModel
        values: {
            const all = [...DesktopEntries.applications.values]
            const q = launcher.query.toLowerCase().trim()
            if (!q) return all
            return all.filter(e =>
                (e.name || "").toLowerCase().includes(q) ||
                (e.comment || "").toLowerCase().includes(q) ||
                (e.keywords || []).join(" ").toLowerCase().includes(q))
        }
    }

    Rectangle {
        anchors.fill: parent
        radius: Theme.rLg
        color: Theme.panelFill
        border { width: 1; color: Theme.panelBorder }
    }

    GlassSheen { anchors.fill: parent; radius: Theme.rLg }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 12

        TextField {
            id: search
            Layout.fillWidth: true
            placeholderText: "Type to search applications…"
            font.family: Theme.fontSans
            font.pixelSize: 14
            color: Theme.onSurface
            focus: true
            background: Rectangle {
                radius: Theme.rSm
                color: Theme.surfaceContainer
                border { width: 1; color: Theme.panelBorder }
            }
            onTextChanged: {
                launcher.query = text
                grid.currentIndex = 0
            }
            Keys.onPressed: (event) => {
                if (event.key === Qt.Key_Escape) { ShellState.launcher = false; event.accepted = true }
                else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) { launcher.launch(grid.currentIndex); event.accepted = true }
                else if (event.key === Qt.Key_Down) { grid.currentIndex = Math.min(grid.currentIndex + 1, launcher.count - 1); event.accepted = true }
                else if (event.key === Qt.Key_Up) { grid.currentIndex = Math.max(grid.currentIndex - 1, 0); event.accepted = true }
                else if (event.key === Qt.Key_Right) { grid.currentIndex = Math.min(grid.currentIndex + grid.columns, launcher.count - 1); event.accepted = true }
                else if (event.key === Qt.Key_Left) { grid.currentIndex = Math.max(grid.currentIndex - grid.columns, 0); event.accepted = true }
            }
        }

        GridView {
            id: grid
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: appModel
            cellWidth: 104
            cellHeight: 92
            clip: true
            boundsBehavior: Flickable.StopAtBounds
            ScrollBar.vertical: ScrollBar { policy: Qt.ScrollBarAsNeeded }

            delegate: Item {
                required property var modelData
                required property int index
                width: 104
                height: 92

                Rectangle {
                    anchors.fill: parent
                    anchors.margins: 4
                    radius: Theme.rMd
                    color: ma.containsMouse || index === grid.currentIndex
                        ? Theme.surfaceContainerHigh : "transparent"
                    border { width: index === grid.currentIndex ? 1 : 0; color: Theme.accent }
                }

                Column {
                    anchors.centerIn: parent
                    spacing: 6
                    IconImage {
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 38
                        height: 38
                        source: Quickshell.iconPath(modelData.icon || "application-x-executable")
                    }
                    Text {
                        text: modelData.name || ""
                        color: Theme.onSurface
                        font.family: Theme.fontSans
                        font.pixelSize: 11
                        width: 92
                        elide: Text.ElideRight
                        horizontalAlignment: Text.AlignHCenter
                    }
                }

                MouseArea {
                    id: ma
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: { grid.currentIndex = index; launcher.launch(index) }
                }
            }
        }
    }
}
