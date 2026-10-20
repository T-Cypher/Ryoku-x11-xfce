import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.theme
import qs.components
PanelWindow {
    id: win; visible: ShellState.osdVisible
    property var scr: Quickshell.screens.length ? Quickshell.screens[0] : null
    screen: scr; color: "transparent"
    anchors { bottom: true; left: true; right: true }
    margins { bottom: 24; left: scr ? Math.max(10, Math.round((scr.width-280)/2)) : 100; right: scr ? Math.max(10, Math.round((scr.width-280)/2)) : 100 }
    implicitHeight: 56
    Rectangle { anchors.fill: parent; radius: Theme.rPill; color: Theme.panelFill; border { width:1; color: Theme.panelBorder } }
    RowLayout { anchors.fill: parent; anchors.margins: 14; spacing: 10
        IconButton { icon: ShellState.osdKind==="brightness" ? "display-brightness" : "audio-volume-high"; highlightOnHover: false }
        HSlider { Layout.fillWidth: true; value: ShellState.osdValue; interactive: false }
        Txt { text: Math.round(ShellState.osdValue*100)+"%" }
    }
}
