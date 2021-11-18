import QtQuick 2.0
import "my_button_impl.js" as Logic // A new instance of this JavaScript resource
                                    // is loaded for each instance of Button.qml.
// 一个qml共享一个js实例

Row{
    spacing: 2
    Rectangle {
        id: rect
        width: 200
        height: 100
        color: "red"

        MouseArea {
            id: mousearea
            anchors.fill: parent
            onClicked: Logic.onClicked(rect)
        }
    }

    Rectangle {
        id: rect2
        width: 200
        height: 100
        color: "yellow"

        MouseArea {
            id: mousearea2
            anchors.fill: parent
            onClicked: Logic.onClicked(rect2)
        }
    }

    MyButton1{}
    MyButton1{}

}
