import QtQuick 2.0

Item {
    // Now you can access inner.extraProperty, as inner is now an ExtraItem
    property alias inner: innerItem

    ExtraItem {
        id: innerItem
    }
}