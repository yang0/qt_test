import QtQuick 2.0

Rectangle {
    width: 100
    height: width * 2

    focus: true
    Keys.onSpacePressed: {
        height = Qt.binding(function() { return width * 3 })
    }
}