import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Window
import QtQuick.Controls.Material

Rectangle{
    width: 640
    height: 680
    visible: true


    ColumnLayout{
        id: cl
        anchors.fill: parent
        spacing: 0
        height: parent.height

        Rectangle{
            id: r1
            Layout.fillWidth: true
            anchors.top: parent.top
            Layout.minimumHeight:50
            Layout.maximumHeight:1000
            
            Layout.fillHeight: true
            
            // implicitHeight: 200
            Layout.preferredHeight: 200
            color: "blue"

        }
        Rectangle{
            id: r2
            Layout.fillWidth: true
            anchors.top: r1.bottom
            Layout.minimumHeight:50
            Layout.maximumHeight:1000
            Layout.preferredHeight: 100
            Layout.fillHeight: true
            // implicitHeight: handleHeight
            color: "red"
        }
        Rectangle{
            id: r3
            Layout.fillWidth: true
            anchors.top: r2.bottom
            Layout.minimumHeight:50
            Layout.maximumHeight:1000
            Layout.preferredHeight: 200
            Layout.fillHeight: true
            // implicitHeight: handleHeight
            color: "yellow"
        }

    }

    Component.onCompleted:{
        console.log(r1.height)
        console.log(r2.height)
        // r2.Layout.preferredHeight = 400
    }

    // function changeLayoutHeight(){
    //     cl.height
    // }

    // Behavior on height {
    //     ScriptAction { duration: 150 }
    // }

}