// Now-playing indicator (Mpris). Shows transport controls + a scrolling
// "Artist – Title". Hidden when no player is running.
import QtQuick
import Quickshell.Services.Mpris
import qs.theme
import qs.components

Item {
    id: root
    implicitWidth: mediaRow.implicitWidth
    implicitHeight: mediaRow.implicitHeight

    readonly property var player: Mpris.players.values.length > 0 ? Mpris.players.values[0] : null

    visible: root.player !== null

    Row {
        id: mediaRow
        spacing: 4
        IconButton {
            icon: "media-skip-backward"
            tooltip: "Previous"
            onClicked: if (root.player) root.player.previous()
        }
        IconButton {
            icon: (root.player && root.player.isPlaying) ? "media-playback-pause" : "media-playback-start"
            tooltip: "Play / Pause"
            onClicked: if (root.player) root.player.togglePlaying()
        }
        IconButton {
            icon: "media-skip-forward"
            tooltip: "Next"
            onClicked: if (root.player) root.player.next()
        }
        Txt {
            text: root.player ? (root.player.trackArtist + " – " + root.player.trackTitle) : ""
            elide: Text.ElideRight
            width: Math.min(240, paintedWidth)
            maximumLineCount: 1
            color: Theme.onSurfaceVariant
            anchors.verticalCenter: parent.verticalCenter
        }
    }

}
