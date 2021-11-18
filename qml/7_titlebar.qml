import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Window
import QtQuick.Controls.Material

// 自定义标题栏

ApplicationWindow {
    FontLoader { id: webFont; source: "iconfont.ttf" }
    id: root
    visible: true
    width: 480
    height: 100
    title: qsTr("音乐播放器")
    flags: Qt.Window | Qt.FramelessWindowHint   //去标题栏
 
    //记录鼠标移动的位置，此处变量过多会导致移动界面变卡
    property point  clickPos: "0,0"

    Text { 
            text: "setting"               
            anchors.centerIn: parent
            font {
                family: webFont.name
                pointSize: 13
            }
            color: 'grey'
        }


    //背景图
    // Rectangle {
    //     id: rootImage
    //     source: "new/prefix1/background2.png"

    // }
 
    //自定义标题栏
    Rectangle{
        id: mainTitle
        x:0
        y:0
        width: root.width
        height: 30
        color: "#dddddd"
 
        //处理鼠标移动后窗口坐标逻辑
        MouseArea{
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton  //只处理鼠标左键
            onPressed: {    //鼠标左键按下事件
                clickPos = Qt.point(mouse.x, mouse.y)
            }
            onPositionChanged: {    //鼠标位置改变
                //计算鼠标移动的差值
                var delta = Qt.point(mouse.x - clickPos.x, mouse.y - clickPos.y)
                //设置窗口坐标
                root.setX(root.x + delta.x)
                root.setY(root.y + delta.y)
            }
        }
 
        //关闭窗口按钮
        Rectangle {
            id: closeButton
            x:0
            anchors.right: parent.right
            width: parent.height
            height: width
            color: "#dddddd"
            Text { 
                text: "address-book"               
                anchors.centerIn: parent
                font {
                    family: webFont.name
                    pointSize: 13
                }
                color: 'grey'
            }
 
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    Qt.quit()               //退出程序
                }
            }
        }
 
        //最小化窗口按钮
        Rectangle {
            id: minButton
            x: 0
            anchors.right: closeButton.left
            anchors.rightMargin: 1
            width: parent.height
            height: width
            color: "#dddddd"
            Text { 
                text: "minus"               
                anchors.centerIn: parent
                font: {
                    family: webFont.name
                    pointSize: 13
                }
                color: 'grey'
            }
 
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    root.showMinimized()        //窗口最小化
                }
            }
        }
 
    }
}