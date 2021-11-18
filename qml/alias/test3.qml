import QtQuick 2.0

MainItem {
    id: myItem
    inner.extraProperty: 5 // fails
    Component.onCompleted: {
        console.log(myItem.inner.extraProperty)
    }
}