import QtQuick 2.0

// test1和test2的效果是一样的，都是给someText赋值
// someText必须是有text属性的，因为MyLabel中有someText.text这样的引用

MyLabel {
    Text { text: "world!" }
}