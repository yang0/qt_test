import QtQuick
import QtQuick.Controls

Button {
    onClicked: popup.open()

    Popup {
        id: popup

        parent: Overlay.overlay

        x: Math.round((parent.width - width) / 2)
        y: Math.round((parent.height - height) / 2)
        width: 100
        height: 100
    }
}