import QtQuick 2.0

//https://doc-snapshots.qt.io/qt6-6.2/qml-qtquick-transition.html
Rectangle {
    id: rect
    width: 100; height: 100
    color: "red"

    MouseArea {
        id: mouseArea
        anchors.fill: parent
    }

    states: State {
        name: "moved"; when: mouseArea.pressed
        PropertyChanges { target: rect; x: 50; y: 50 }
    }

    transitions: Transition {
        NumberAnimation { properties: "x,y"; easing.type: Easing.InOutQuad }
    }
}