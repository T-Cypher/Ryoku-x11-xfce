// Frosted-glass "sheen" overlay. Stacks on top of a panel's base fill to fake the
// Ryoku glass look on X11 (where true backdrop blur isn't available — see README).
// Clip it to the panel's rounded shape by giving it the same radius.
import QtQuick
import qs.theme

Rectangle {
    id: root
    color: "transparent"
    radius: Theme.rMd
    gradient: Gradient {
        GradientStop {
            position: 0.0
            color: Qt.rgba(Theme.sheen.r, Theme.sheen.g, Theme.sheen.b, Theme.glassTop)
        }
        GradientStop {
            position: 0.45
            color: Qt.rgba(Theme.sheen.r, Theme.sheen.g, Theme.sheen.b, Theme.glassTop * 0.20)
        }
        GradientStop { position: 1.0; color: "transparent" }
    }
}
