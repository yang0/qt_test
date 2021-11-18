import QtQuick 2.7
import QtQuick.Layouts 1.2

// This widget assumes that the parent contains a currentItem property which
// points to the AccordionWidget currently selected
Item {
    id: root
    default property var contentItem: null
    property string title: "panel"

    readonly property int expandMinimumHeight: 100
    Layout.fillWidth: true
    Layout.fillHeight: current

    property bool current: false
    property int handleHeight: 4
    property int barHeight: 50
    property int fixedHeight: handleHeight + barHeight
    implicitHeight: fixedHeight


    // 当拖拉操作可能过多时，修剪掉多余的位移值
    function fineOffsetY(srcOffsetY, itemHeight, minItemHeight){
        if(itemHeight - srcOffsetY < minItemHeight){
            return itemHeight - minItemHeight
        }

        return srcOffsetY
    }

    ColumnLayout {
        id: clayout
        anchors.fill: parent
        spacing: 0
        

        Rectangle {
            id: handle
            Layout.fillWidth: true
            implicitHeight: handleHeight
            color: "#CEECF5"

            MouseArea{
                property point startPoint: Qt.point(0, 0);
                property int minY : 0
                property int maxY : 0
                anchors.fill: parent
                hoverEnabled: true
                onEntered:{
                    var nodes = root.parent.children
                    var preNode = undefined
                    for (var i = 0; i < nodes.length; i++){
                        if(String(node).slice(0,15) !== "AccordionWidget") continue
                        var node = nodes[i]
                        if(node.y === root.y && node.x === root.x){
                            if(preNode === undefined || !preNode.current) {
                                console.log("不让拉") 
                            }
                            return
                        }
                        preNode = node
                    }

                    parent.color = "red"
                    cursorShape = Qt.SizeVerCursor;
                }
                onExited:{
                    parent.color = "#CEECF5"
                    cursorShape = Qt.ArrowCursor;
                }
                onPressed: (mouse)=>{
                    startPoint = Qt.point(mouse.x, mouse.y)
                    minY = 0
                    maxY = 0

                    var nodes = root.parent.children
                    var belowCurrent = false
                    console.log("root.parent.height" + root.parent.height)
                    for (var i = 0; i < nodes.length; i++){
                        var node = nodes[i]
                        if(String(node).slice(0,15) === "AccordionWidget"){
                            console.log("=============" + node.title + ".height: " + node.height)
                            
                            if(!belowCurrent){
                                // 处理最高可以拉到哪个位置
                                console.log("node.y:" + node.y + "root.y:" + root.y)
                                if(node.y === root.y && node.x === root.x){
                                    maxY = root.parent.height - root.expandMinimumHeight
                                    belowCurrent = true   
                                    continue
                                }
                                if(node.current){ //如果是展开状态，那么要保留一部分显示区域
                                    minY += node.expandMinimumHeight
                                }else{
                                    minY += node.fixedHeight
                                }
                            }else{
                                
                                if(node.current){
                                    maxY -= node.expandMinimumHeight
                                }else{
                                    maxY -= node.fixedHeight
                                }
                                // console.log("maxY: ===="+maxY)
                            }
                        }
                    }

                    

                }

                onPositionChanged:(mouse)=>{
                    var nodes = root.parent.children
                    var preNode = undefined
                    for (var i = 0; i < nodes.length; i++){
                        var node = nodes[i]
                        if(String(node).slice(0,15) !== "AccordionWidget") continue
                        if(node.y === root.y && node.x === root.x){
                            if(preNode === undefined || !preNode.current) {
                                console.log("bbbbb拉") 
                                return
                            }
                            break
                        }
                        
                        preNode = node
                    }


                    console.log(preNode.title + " height: " + preNode.height)
                    

                    if(pressed && current && (root.y - root.parent.y) > 5)
                    {
                        var offsetY = mouse.y - startPoint.y;
                        console.log("minY: "+ minY + " maxY: " + maxY + "  root.y: " + root.y)
                        if ((root.y > minY && offsetY < 0) || (root.y < maxY && offsetY > 0))
                        {
                            console.log(root.height)
                            root.y += offsetY;

                            var belowCurrent = true
                            if(offsetY < 0){
                                root.height -= offsetY;
                                for (var i = nodes.length-1; i >=0;  i--){
                                    var node = nodes[i]
                                    if(String(node).slice(0,15) !== "AccordionWidget") continue
                                    if(node.y === root.y && node.x === root.x){
                                        belowCurrent = false
                                        continue
                                    }
                                    if(belowCurrent) continue


                                    if(node.current){
                                        console.log(node.title)
                                        if(node.height <= node.expandMinimumHeight){
                                            node.y += offsetY    
                                        }else{
                                            node.height += offsetY
                                        }
                                        break
                                    }else{
                                        node.y += offsetY
                                    }
                                }
                            }else{
                                belowCurrent = false
                                preNode.height += offsetY //调整上面的节点高度
                                console.log(preNode.title + " height: " + preNode.height)
                                console.log(root.title + " height: " + root.height)

                                if(root.height > root.expandMinimumHeight){ //往下拉的时候，如果本节点还没有缩到最小，那么就不用去动其他节点
                                    offsetY = fineOffsetY(offsetY, root.height, root.expandMinimumHeight)
                                    root.height -= offsetY;  
                                    console.log("offsetY: " + offsetY +  " 缩短操作1后：" + root.title + ".height: " + root.height)
                                    return 
                                } 
                                for (var i = 0; i < nodes.length; i++){
                                    var node = nodes[i]
                                    if(String(node).slice(0,15) !== "AccordionWidget") continue
                                    if(node.y === root.y && node.x === root.x){
                                        belowCurrent = true
                                        continue
                                    }
                                    if(!belowCurrent) continue

                                    if(node.current){
                                        console.log(node.title)
                                        if(node.height <= node.expandMinimumHeight){
                                            node.y += offsetY
                                        }else{
                                            offsetY = fineOffsetY(offsetY, node.height, node.expandMinimumHeight)
                                            node.height -= offsetY
                                            node.y += offsetY
                                            console.log("缩短操作2后：" + node.title + ".height: " + node.height)
                                        }
                                        break
                                    }else{
                                        node.y += offsetY
                                    }
                                }
                            }
                        }
                    }
                }


            }
        }

        Rectangle {
            id: bar
            radius: 2
            Layout.fillWidth: true
            implicitHeight: barHeight
            color:  root.current ? "#81BEF7" : "#CEECF5"

            Text {
                anchors.fill: parent
                anchors.margins: 10
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                text: root.title
            }

            Text {
                anchors{
                    right: parent.right
                    top: parent.top
                    bottom: parent.bottom
                    margins: 10
                }
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                text: "^"
                rotation: root.current ? "180" : 0
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    root.current = !root.current;
                    console.debug(root, root.current, root.title)
                    // if(root.parent.currentItem !== null) {
                    //     console.debug(root.parent.currentItem)

                    //     // Retract the currently expanded option
                    //     root.parent.currentItem.current = false;

                    //     // Reset the root
                    //     root.parent.currentItem = root;
                    // }

                }
            }
        }

        Rectangle {
            id: container
            Layout.fillWidth: true
            implicitHeight: root.height - root.fixedHeight
            clip: true
            Behavior on implicitHeight {
                PropertyAnimation { duration: 200 }
            }
        }

        Component.onCompleted: {
            if(root.contentItem !== null){
                root.contentItem.parent = container;
            }
        }
    }
}
