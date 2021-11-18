
import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material

Item {
  height: 200
  width:  200
  
  
  property var baseColor: "#112244"
  
  Button {
    id: b
    anchors.fill:parent
    state: "RELEASED"



    icon {
      source:  Qt.resolvedUrl("iconmonstr-gear-10-icon.svg")
      width: parent.width
      height: parent.height
    }

    PropertyAnimation {id: animateColor1;  target: b; properties: "icon.color"; to: "blue"; duration: 300}
    PropertyAnimation {id: animateColor2; target: b; properties: "icon.color"; to: "red"; duration: 300}

    HoverHandler {
      onHoveredChanged: {
        if(hovered){
          b.state = "PRESSED"
          // animateColor1.start()
        }else{
          // animateColor2.start()
          b.state = "RELEASED"
        }
      }
    }

    states: [
        State {
            name: "PRESSED"
            PropertyChanges { target: b; icon.color: "blue"; background.color: "grey"}
        },
        State {
            name: "RELEASED"
            PropertyChanges { target: b; icon.color: "red"; background.color: "white"}
        }
    ]

    transitions: [
        Transition {
            from: "PRESSED"
            to: "RELEASED"
            ColorAnimation { target: b; duration: 300}
        },
        Transition {
            from: "RELEASED"
            to: "PRESSED"
            ColorAnimation { target: b; duration: 300}
        }
    ]

    

  }
}
