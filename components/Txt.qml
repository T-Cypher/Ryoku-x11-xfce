// Themed text helper. Use instead of a bare Text so everything shares the
// Ryoku font stack and on-surface colour.
import QtQuick
import qs.theme

Text {
    color: Theme.onSurface
    font.family: Theme.fontSans
    font.pixelSize: 13
    font.weight: Font.Medium
}
