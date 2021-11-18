import QtQuick 2.0

SquareButton {
    onDeactivated: console.log("Deactivated!")
    onActivated: (xPosition, yPosition)=> console.log("Activated at " + xPosition + "," + yPosition)
}