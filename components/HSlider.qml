import QtQuick
import qs.theme
Item {
    id: root
    property real value: 0
    property color color: Theme.accent
    property bool interactive: true
    signal moved(real v)
    implicitHeight: 14; implicitWidth: 200
    Rectangle { anchors { left: parent.left; right: parent.right; verticalCenter: parent.verticalCenter } height: 6; radius: 3; color: Theme.surfaceContainerHigh }
    Rectangle { anchors { left: parent.left } y: parent.height/2-3; width: Math.max(0,Math.min(1,root.value))*parent.width; height: 6; radius: 3; color: root.color }
    Rectangle { x: Math.round(Math.max(0,Math.min(1,root.value))*parent.width-7); anchors.verticalCenter: parent.verticalCenter; width: 14; height: 14; radius: 7; color: root.color; visible: root.interactive }
    MouseArea { anchors.fill: parent; enabled: root.interactive; hoverEnabled: true
        onPressed: m => setFromX(m.x); onPositionChanged: m => { if (pressed) setFromX(m.x) }
        function setFromX(x) { const v=Math.max(0,Math.min(1,x/parent.width)); root.value=v; root.moved(v) } }
}
