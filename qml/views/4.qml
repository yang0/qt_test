import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.2
import QtQuick.Controls 2.12

Window {
    id: window
    width: 640
    height: 680
    visible: true
    title: qsTr("Hello World")
    ColumnLayout {
//        anchors.fill: parent
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        width: 100
        spacing: 1
        property var currentItem: null

        AccordionWidget {
            id: sandboxButton
            title: "Ventilation"
            ColumnLayout {
                anchors.fill: parent
                spacing: 1
                property var currentItem: null
                Button {
                    height: parent.height / 3
                    text: "Setup Vent"
                }

                Button {
                    height: parent.height / 3
                    text: "Apnea"
                }

                Button {
                    height: parent.height / 3
                    text: "Alarms"
                }
            }
        }

        AccordionWidget {
            title: "Therapy 1"
            Rectangle {
                color: "white"
                anchors.fill: parent
            }
        }

        AccordionWidget {
            title: "Therapy 2"
            Rectangle {
                color: "white"
                anchors.fill: parent
            }
        }


        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }
}
