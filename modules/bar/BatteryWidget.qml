// Battery via UPower (declarative bindings - no Connections/polling).
import QtQuick
import Quickshell.Services.UPower
import qs.theme
import qs.components
Item {
    id: root
    implicitWidth: batRow.implicitWidth
    implicitHeight: batRow.implicitHeight
    readonly property var dd: UPower.displayDevice
    readonly property bool hasBattery: {
        for (let i = 0; i < UPower.devices.values.length; i++) {
            const d = UPower.devices.values[i]
            if (d.isLaptopBattery && d.isPresent) return true
        }
        return false
    }
    readonly property real percent: (dd && dd.ready) ? dd.percentage : 0
    // UPowerDeviceState: 1 = Charging, 5 = PendingCharge
    readonly property bool charging: dd ? (dd.state === 1 || dd.state === 5) : false
    readonly property string devIcon: (dd && dd.ready) ? dd.iconName : ""
    visible: root.hasBattery
    Row {
        id: batRow
        spacing: 6
        IconButton { icon: root.devIcon || "battery-full"; tooltip: Math.round(root.percent) + "%" + (root.charging ? " (charging)" : ""); size: 18 }
        Txt { text: Math.round(root.percent) + "%"; anchors.verticalCenter: parent.verticalCenter; color: root.charging ? Theme.accentSoft : Theme.onSurface }
    }
}
