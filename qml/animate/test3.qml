import QtQuick

Rectangle {
    id: flashingblob
    width: 75; height: 75
    color: "blue"
    opacity: 1.0

    MouseArea {
        anchors.fill: parent
        onClicked: {
            animateColor.start()
            // animateOpacity.start()
        }
    }

    PropertyAnimation {id: animateColor; target: flashingblob; properties: "color"; to: "green"; duration: 500}

    NumberAnimation {
        id: animateOpacity
        target: flashingblob
        properties: "opacity"
        from: 0.99
        to: 1.0
        loops: Animation.Infinite
        easing {type: Easing.OutBack; overshoot: 500}
   }
}