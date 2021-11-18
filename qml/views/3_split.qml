import QtQuick
import QtQuick.Controls


SplitView {
    id: splitView
    anchors.fill: parent
    height: Screen.desktopAvailableHeight * 0.8
    // orientation: Qt.Horizontal
    orientation: Qt.Vertical
    // anchors.bottomMargin: 300

    // handle: Rectangle {
    //     // implicitWidth: 4
    //     // implicitHeight: 4
    //     color: SplitHandle.pressed ? "#81e889"
    //         : (SplitHandle.hovered ? Qt.lighter("#c2f4c6", 1.1) : "#c2f4c6")

    //     // containmentMask: Item {
    //     //     x: -width / 2
    //     //     width: 64
    //     //     height: splitView.height
    //     // }
    // }

    handle: Rectangle {
        implicitWidth: 4
        implicitHeight: 4
        color: SplitHandle.hovered ? "#007ed4" : "#666"



        MouseArea{
            x: parent.x -2
            y: parent.y -2
            width: parent.width + 4
            height: parent.height + 4
            hoverEnabled: true
            onClicked: (mouse)=> {
                console.log(mouse.y)
                console.log(SplitHandle.hovered)
            }
            onPositionChanged: (mouse)=> {
                if(mouse.y > header2.y-5 && mouse.y < header2 + 5){
                    console.log(SplitHandle.hovered)
                    console.log("aaaa")
                }
            }
        }
    }


    Rectangle {
        // implicitWidth: 150
        height: 20
        implicitHeight: 20
        color: "#dddddd"
    }
    Rectangle {
        // implicitWidth: 150
        implicitHeight: 150
        color: "#444"
    }
    Rectangle {
        // implicitWidth: 150
        id: header2
        height: 20
        implicitHeight: 20
        color: "#dddddd"
        MouseArea{
            anchors.fill: parent
            onClicked:{
                console.log(rec2.implicitHeight)
                rec2.height = rec2.height === 0 ? 50:0
            }
            
        }
        
    }
    Rectangle {
        id: rec2
        implicitHeight: 50
        // implicitWidth: 50
        color: "#666"
    }


   

    
    Component.onCompleted: {
        console.log(header2.y)
    }
    
}


