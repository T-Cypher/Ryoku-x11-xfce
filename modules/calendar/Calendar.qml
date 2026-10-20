import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.theme
import qs.components
PanelWindow {
    id: win; visible: ShellState.calendar
    property var scr: Quickshell.screens.length ? Quickshell.screens[0] : null
    screen: scr; color: "transparent"; focusable: true
    anchors { top: true; left: true; right: true }
    margins { top: 58; left: scr ? Math.max(10, Math.round((scr.width-320)/2)) : 100; right: scr ? Math.max(10, Math.round((scr.width-320)/2)) : 100 }
    implicitHeight: 360
    property var today: new Date()
    property var shown: new Date(today.getFullYear(), today.getMonth(), 1)
    function daysIn(y,m){ return new Date(y,m+1,0).getDate() }
    function firstDow(y,m){ return (new Date(y,m,1).getDay()+6)%7 } // Mon=0
    Rectangle { anchors.fill: parent; radius: Theme.rLg; color: Theme.panelFill; border { width:1; color: Theme.panelBorder } }
    GlassSheen { anchors.fill: parent; radius: Theme.rLg }
    Item { anchors.fill: parent; focus: win.visible; Keys.onPressed: e => { if (e.key === Qt.Key_Escape) ShellState.calendar = false } }
    ColumnLayout { anchors.fill: parent; anchors.margins: 16; spacing: 10
        RowLayout { Layout.fillWidth: true
            IconButton { icon: "go-previous"; onClicked: win.shown = new Date(win.shown.getFullYear(), win.shown.getMonth()-1, 1) }
            Txt { Layout.fillWidth: true; horizontalAlignment: Text.AlignHCenter; font.pixelSize: 15; font.weight: Font.DemiBold; text: Qt.formatDate(win.shown, "MMMM yyyy") }
            IconButton { icon: "go-next"; onClicked: win.shown = new Date(win.shown.getFullYear(), win.shown.getMonth()+1, 1) }
        }
        RowLayout { Layout.fillWidth: true; Repeater { model: ["Mo","Tu","We","Th","Fr","Sa","Su"]; delegate: Txt { required property var modelData; Layout.fillWidth: true; horizontalAlignment: Text.AlignHCenter; color: Theme.onSurfaceVariant; font.pixelSize: 11; text: modelData } } }
        GridLayout { Layout.fillWidth: true; Layout.fillHeight: true; columns: 7; rowSpacing: 4; columnSpacing: 4
            Repeater { model: 42
                delegate: Rectangle { required property int index; Layout.fillWidth: true; Layout.fillHeight: true; radius: Theme.rSm
                    property int day: index - win.firstDow(win.shown.getFullYear(), win.shown.getMonth()) + 1
                    property bool inMonth: day >= 1 && day <= win.daysIn(win.shown.getFullYear(), win.shown.getMonth())
                    property bool isToday: inMonth && day===win.today.getDate() && win.shown.getMonth()===win.today.getMonth() && win.shown.getFullYear()===win.today.getFullYear()
                    color: isToday ? Theme.accent : "transparent"; border { width: isToday?0:0; color: Theme.panelBorder }
                    Txt { anchors.centerIn: parent; text: parent.inMonth ? parent.day : ""; color: parent.isToday ? Theme.onTertiary : Theme.onSurface; font.pixelSize: 12 }
                }
            }
        }
        Txt { Layout.alignment: Qt.AlignHCenter; color: Theme.onSurfaceVariant; text: Qt.formatDate(win.today, "dddd, d MMMM yyyy") }
    }
    onVisibleChanged: if (visible) { win.today=new Date(); win.shown=new Date(win.today.getFullYear(), win.today.getMonth(), 1) }
}
