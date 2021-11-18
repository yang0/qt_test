import QtQuick
import QtQuick.Controls

SplitView {
    anchors.fill: parent
    orientation: Qt.Horizontal

    Rectangle {
        implicitWidth: 200
        SplitView.maximumWidth: 400
        color: "lightblue"
        Text {
            text: "View 1"
            anchors.centerIn: parent
        }
    }
    Rectangle {
        id: centerItem
        SplitView.minimumWidth: 50
        SplitView.fillWidth: true
        color: "lightgray"
        Text {
            text: "View 2"
            anchors.centerIn: parent
        }
    }
    Rectangle {
        implicitWidth: 200
        color: "lightgreen"
        Text {
            text: "View 3"
            anchors.centerIn: parent
        }
    }
}