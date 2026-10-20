// Compact now-playing card for the control center. Binds to the first MPRIS
// player, with artwork, transport controls and a progress bar.
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Mpris
import qs.theme
import qs.components

Item {
    id: root
    readonly property var player: Mpris.players.values.length > 0 ? Mpris.players.values[0] : null

    visible: root.player !== null
    Layout.fillWidth: true
    implicitHeight: 72


    Rectangle {
        anchors.fill: parent
        radius: Theme.rMd
        color: Theme.surfaceContainer
        border { width: 1; color: Theme.panelBorder }

        RowLayout {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 10

            Rectangle {
                width: 52
                height: 52
                radius: 8
                color: Theme.surfaceContainerHigh
                clip: true
                IconImage {
                    anchors.centerIn: parent
                    width: 26
                    height: 26
                    source: Quickshell.iconPath("audio-x-generic")
                    visible: !(root.player && root.player.trackArtUrl)
                }
                Image {
                    anchors.fill: parent
                    source: root.player ? root.player.trackArtUrl : ""
                    fillMode: Image.PreserveAspectCrop
                    visible: root.player && root.player.trackArtUrl !== ""
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 3
                Txt {
                    text: root.player ? (root.player.trackTitle || "Unknown Title") : ""
                    elide: Text.ElideRight
                    font.weight: Font.DemiBold
                }
                Txt {
                    text: root.player ? (root.player.trackArtist || "Unknown Artist") : ""
                    elide: Text.ElideRight
                    color: Theme.onSurfaceVariant
                    font.pixelSize: 11
                }
                HSlider {
                    Layout.fillWidth: true
                    value: (root.player && root.player.length > 0) ? root.player.position / root.player.length : 0
                    color: Theme.accent; interactive: false
                }
            }

            Column {
                spacing: 2
                IconButton { icon: "media-skip-backward"; size: 18; onClicked: if (root.player) root.player.previous() }
                IconButton {
                    icon: (root.player && root.player.isPlaying) ? "media-playback-pause" : "media-playback-start"
                    size: 18
                    onClicked: if (root.player) root.player.togglePlaying()
                }
                IconButton { icon: "media-skip-forward"; size: 18; onClicked: if (root.player) root.player.next() }
            }
        }
    }
}
