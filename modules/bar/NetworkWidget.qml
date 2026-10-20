// Network status via NetworkManager (nmcli). Shows Wi-Fi SSID, wired LAN, or
// offline; left-click toggles the Wi-Fi radio.
import QtQuick
import Quickshell
import Quickshell.Io
import qs.theme
import qs.components

Item {
    id: root
    implicitWidth: netRow.implicitWidth
    implicitHeight: netRow.implicitHeight

    property string state: "unknown"   // "wifi" | "wired" | "off" | "none"
    property string ssid: ""
    property bool wifiOn: true
    property bool wired: false
    function recompute(): void { state = ssid ? "wifi" : (wired ? "wired" : (wifiOn ? "none" : "off")) }

    function refresh(): void { if (!proc.running) proc.running = true }
    function toggleWifi(): void {
        action.exec({ command: ["nmcli", "radio", "wifi", root.wifiOn ? "off" : "on"] })
        rt.restart()
    }

    Row {
        id: netRow
        spacing: 6
        IconButton {
            icon: root.state === "wifi" ? "network-wireless"
                : (root.state === "wired" ? "network-wired" : "network-offline")
            tooltip: root.ssid ? root.ssid : (root.state === "wired" ? "Wired" : "Offline")
            onClicked: root.toggleWifi()
        }
        Txt {
            text: root.state === "wifi" ? root.ssid
                : (root.state === "wired" ? "LAN" : "Off")
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    Process {
        id: proc
        running: true
        command: ["sh", "-c",
            "echo WIFI=$(nmcli radio wifi); " +
            "echo CONN=$(nmcli -t -f STATE,TYPE dev | tr '\\n' ';'); " +
            "echo SSID=$(nmcli -t -f active,ssid dev wifi | grep '^yes:' | head -1)"]
        stdout: SplitParser {
            onRead: data => {
                const line = data.trim()
                if (line.startsWith("WIFI=")) {
                    root.wifiOn = line.slice(5).trim() === "enabled"
                } else if (line.startsWith("CONN=")) {
                    const parts = line.slice(5).split(";")
                    root.wired = false
                    for (const p of parts) { const kv = p.split(":"); if (kv.length >= 2 && kv[1] === "ethernet" && kv[0] === "connected") root.wired = true }
                    root.recompute()
                } else if (line.startsWith("SSID=")) {
                    const v = line.slice(5).trim()
                    root.ssid = v.startsWith("yes:") ? v.slice(4) : ""; root.recompute()
                }
            }
        }
    }
    Process { id: action }
    Timer { id: rt; interval: 300; onTriggered: root.refresh() }
    Timer { interval: 4000; running: true; repeat: true; onTriggered: root.refresh() }
    Component.onCompleted: root.refresh()
}
