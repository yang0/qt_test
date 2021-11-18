import QtQuick 2.7
import QtQuick.Layouts 1.2

// This widget assumes that the parent contains a currentItem property which
// points to the AccordionWidget currently selected
Item {
    id: root
    default property var contentItem: null
    property string title: "panel"
    property int index: 0
    property var accordionNodes: []

    readonly property int expandMinimumHeight: 100
    Layout.fillWidth: true
    Layout.fillHeight: current

    property bool current: false
    property int handleHeight: 4
    property int barHeight: 50
    property int fixedHeight: handleHeight + barHeight
    implicitHeight: fixedHeight
    property bool canZoomout: height > expandMinimumHeight && current


    // 当拖拉操作可能过多时，修剪掉多余的位移值
    function fineOffsetY(srcOffsetY, itemHeight, minItemHeight){
        if(itemHeight - srcOffsetY < minItemHeight){
            return itemHeight - minItemHeight
        }
        return srcOffsetY
    }

    //下压, 调整节点Y值
    function adjustDownY(offset, activeNode){
        console.log("[adjustDownY] offset:" + offset + " activeNode: " + activeNode.title)
        var upExpandNode = undefined //当前节点上方最近的展开节点
        for(var i=0; i < root.index; i++){
            var node = accordionNodes[i]
            if(node.current) upExpandNode=node
        }

        for(var i=0; i < accordionNodes.length; i++){
            var node = accordionNodes[i]
            console.log(node.title + " | index: " + node.index)
            if(node.index <= activeNode.index && node.index > upExpandNode.index){
                console.log(node.title + " 调整Y值：" + offset)
                node.y += offset
            }
        }

        upExpandNode.height += offset
    }


    //上推, 调整节点Y值
    function adjustUpY(offset, activeNode){
        console.log("[adjustUpY] offset:" + offset + " activeNode: " + activeNode.title)
        var downExpandNode = undefined //当前节点下方最近的展开节点
        for(var i=accordionNodes.length-1; i >= root.index; i--){
            var node = accordionNodes[i]
            if(node.current) downExpandNode=node
        }

        for(var i=accordionNodes.length-1; i >= 0; i--){
            var node = accordionNodes[i]
            if(node.index > activeNode.index && node.index <= downExpandNode.index){
                console.log(node.title + " 调整Y值：" + offset)
                node.y += offset
            }
        }

        downExpandNode.height -= offset
    }

    // 压缩Item, 返回真实的压缩值
    function zoomOutItem(offsetY, item){
        var dragUp = false
        if(offsetY < 0){//取反
            dragUp = true
            offsetY = 0 - offsetY
        }
        var minItemHeight = item.expandMinimumHeight
        if(!item.current) minItemHeight = item.fixedHeight
        var itemOffset = fineOffsetY(offsetY, item.height, minItemHeight)
        if(itemOffset <= 0) return 0 // 已到达最小高度，无法再压缩
        item.height -= itemOffset //调整高度
        if(dragUp){
            itemOffset = 0 - itemOffset // 再次变成负值
            adjustUpY(itemOffset, item)
        }else{
            adjustDownY(itemOffset, item)
        }
        
        return itemOffset
    }

    // 判断当前节点是否能拖拉
    function canDrag(){
        var canUp = false
        var canDown = false
        var upExpandNodes = 0
        var downExpandNodes = 0

        for(var i = 0; i < root.accordionNodes.length; i++){
            if(root.index === 0) return
            var node = root.accordionNodes[i]
            if(node.index < root.index){
                if(node.current) upExpandNodes++
                if(node.canZoomout)  canUp = true
            }else{
                if(node.current) downExpandNodes++
                if(node.canZoomout) canDown = true
            }
        }
        // console.log("canUp: "+canUp+" canDown: "+canDown+" upExpandNodes: "+upExpandNodes+" downExpandNodes: "+downExpandNodes)
        if(!canUp){
            if(!canDown || upExpandNodes === 0) return false
        }else{
            if(downExpandNodes === 0) return false
        }

        return true
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
                property var preNode : undefined
                property var belowNodes : []
                anchors.fill: parent
                hoverEnabled: true
                onEntered:{
                    if(!canDrag()) return
                    parent.color = "red"
                    cursorShape = Qt.SizeVerCursor;
                }
                onExited:{
                    parent.color = "#CEECF5"
                    cursorShape = Qt.ArrowCursor;
                }
                onPressed: (mouse)=>{
                    startPoint = Qt.point(mouse.x, mouse.y)
                    container.enableBehavior = false

                }

                onPositionChanged:(mouse)=>{
                    if(pressed && canDrag()){
                        var offsetY = mouse.y - startPoint.y;

                        if(offsetY < 0){
                            for(var i = root.index-1; i >= 0; i--){
                                var node = root.accordionNodes[i]
                                if(node.canZoomout){
                                    var itemOffset = zoomOutItem(offsetY, node)
                                    if(offsetY < itemOffset){
                                        offsetY -= itemOffset
                                    }else{
                                        return
                                    }
                                }
                            }
                        }
                        

                        if(offsetY > 0){
                            for(var i=root.index; i < root.accordionNodes.length; i++){
                                var node = root.accordionNodes[i]
                                if(node.canZoomout){
                                    var itemOffset = zoomOutItem(offsetY, node)
                                    if(itemOffset < offsetY){
                                        offsetY -= itemOffset
                                    }else{
                                        return
                                    }
                                }
                            }
                        } //offset > 0
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
                    container.enableBehavior = true
                    root.current = !root.current;
                }
            }
        }

        Rectangle {
            id: container
            property bool enableBehavior: false
            Layout.fillWidth: true
            implicitHeight: root.height - root.fixedHeight
            clip: true
            
            Behavior on implicitHeight {
                enabled: container.enableBehavior
                PropertyAnimation { duration: 200 }
            }
        }

        Component.onCompleted: {
            if(root.contentItem !== null){
                root.contentItem.parent = container;
            }
        }
    }


    Component.onCompleted:{
        var nodes = root.parent.children
        var nodeIndex = 0
        for (var i = 0; i < nodes.length; i++){
            var node = nodes[i]
            if(String(node).slice(0,15) !== "AccordionWidget") continue
            node.index = nodeIndex
            accordionNodes[nodeIndex] = node
            nodeIndex++
        }
    }



    
}
