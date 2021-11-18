import QtQuick 2.0

Rectangle {
    id: root

    signal activated(real xPosition, real yPosition)
    signal deactivated

    property int side: 100
    width: side; height: side

    MouseArea {
        anchors.fill: parent
        onReleased: root.deactivated()
        onPressed: (mouse)=> root.activated(mouse.x, mouse.y)
    }
}