import QtQuick 2.0

//父类的color被重载成子类的color，后面就无法对父类的color赋值了s

Rectangle {
    id: coloredrectangle
    color: "red"
    property alias color: bluerectangle.color
    // color: "red"

    Rectangle {
        id: bluerectangle
        color: "#1234ff"
    }

    Component.onCompleted: {
        console.log (coloredrectangle.color)    //prints "#1234ff"
        console.log(bluerectangle.color)
        setInternalColor()
        console.log (coloredrectangle.color)    //prints "#111111"
        coloredrectangle.color = "#884646"
        console.log (coloredrectangle.color)    //prints #884646
        console.log(bluerectangle.color)
    }

    //internal function that has access to internal properties
    function setInternalColor() {
        color = "#111111"
    }
}