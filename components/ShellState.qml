pragma Singleton
import QtQuick
QtObject {
    id: _state
    property bool controlCenter: false
    property bool launcher: false
    property bool powerMenu: false
    property bool calendar: false
    property string osdKind: ""      // "volume" | "brightness"
    property real osdValue: 0        // 0..1
    property bool osdVisible: false
    function openOnly(which) {
        controlCenter = which==="controlCenter"; launcher = which==="launcher";
        powerMenu = which==="powerMenu"; calendar = which==="calendar";
    }
    function toggleControlCenter() { controlCenter ? closeAll() : openOnly("controlCenter") }
    function toggleLauncher() { launcher ? closeAll() : openOnly("launcher") }
    function togglePowerMenu() { powerMenu ? closeAll() : openOnly("powerMenu") }
    function toggleCalendar() { calendar ? closeAll() : openOnly("calendar") }
    function closeAll() { controlCenter=false; launcher=false; powerMenu=false; calendar=false }
    function showOsd(kind, value) { osdKind=kind; osdValue=Math.max(0,Math.min(1,value)); osdVisible=true; osdTimer.restart() }
    property Timer osdTimer: Timer { interval: 1400; onTriggered: _state.osdVisible=false }
}
