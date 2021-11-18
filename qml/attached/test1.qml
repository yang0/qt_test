import QtQuick 2.0

// 有3条数据，当前数据显示红色，非当前的显示黄色
// delegate 其实相当于选来作为view的组件,在这个例子中rectangle被重复了三次
// 因为 model:3
// attache的属性只对子有效，对孙无效，孙要引用，必须先引用子
ListView {
    width: 240; height: 320
    model: 3
    delegate: Rectangle {
        width: 100; height: 30
        color: ListView.isCurrentItem ? "red" : "yellow"
    }
}