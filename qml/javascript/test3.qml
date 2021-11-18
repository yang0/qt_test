import QtQuick 2.0

Rectangle {
    function startupFunction() {
        console.log("start...")
    }

    Component.onCompleted: startupFunction();
}