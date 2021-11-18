import QtQuick

// 串联signal
Rectangle {
    id: forwarder
    width: 100; height: 100

    signal send()
    onSend: console.log("Send clicked")

    TapHandler {
        id: mousearea
        onTapped: console.log("Mouse clicked")
    }

    Component.onCompleted: {
        mousearea.tapped.connect(send)
    }
}