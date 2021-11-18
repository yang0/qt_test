import QtQuick 2.0

ListView {
    width: 240; height: 320
    model: 3
    delegate: Item {
        id: delegateItem
        width: 100; height: 30

        Rectangle {
            width: 100; height: 30
            color: delegateItem.ListView.isCurrentItem ? "red" : "yellow"    // WRONG! This won't work.
        }
    }
}