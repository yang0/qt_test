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

    property bool current: false
    readonly property int expandMinimumHeight: 100
    property int handleHeight: 4
    property int barHeight: 50
    property int fixedHeight: handleHeight + barHeight
    Layout.fillWidth: true
    Layout.fillHeight: current
    Layout.minimumHeight: current ? expandMinimumHeight : fixedHeight
    Layout.maximumHeight:99999
    Layout.preferredHeight: fixedHeight

    // implicitHeight: fixedHeight
    property bool canZoomout: height > expandMinimumHeight && current
    property int preservedHeight: expandMinimumHeight
    

    function clickZoomInItem(){
        root.Layout.preferredHeight = preservedHeight
    }

    function clickZoomOutItem(){
        root.Layout.preferredHeight = fixedHeight
    }

    // 展开或收拢当前节点
    function clickZoomItem(){
        root.current = !root.current
        if(current){
            clickZoomInItem()
        }else{
            clickZoomOutItem()
        }
    }

    // 当拖拉操作可能过多时，修剪掉多余的位移值
    function fineOffsetY(srcOffsetY, itemHeight, minItemHeight){
        if(itemHeight - srcOffsetY < minItemHeight){
            return itemHeight - minItemHeight
        }
        return srcOffsetY
    }

    // 压缩Item, 返回真实的压缩值
    function dragZoomOutItem(offsetY, item){
        var dragUp = false
        if(offsetY < 0){//取正
            dragUp = true
            offsetY = 0 - offsetY
        }
        var minItemHeight = item.expandMinimumHeight
        if(!item.current) minItemHeight = item.fixedHeight
        var itemOffset = fineOffsetY(offsetY, item.height, minItemHeight)
        if(itemOffset <= 0) return 0 // 已到达最小高度，无法再压缩
        item.Layout.preferredHeight -= itemOffset //调整高度
        if(dragUp){
            itemOffset = 0 - itemOffset // 再次变成负值
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
        console.log("canUp: "+canUp+" canDown: "+canDown+" upExpandNodes: "+upExpandNodes+" downExpandNodes: "+downExpandNodes)
        if(!canUp){
            if(!canDown || upExpandNodes === 0) return false
        }else{
            if(downExpandNodes === 0) return false
        }

        return true
    }

    function upNodes(){
        //上方节点
        return accordionNodes.slice(0, root.index).reverse()
    }

    function downNodes(){
        //包括自己及下方节点
        return accordionNodes.slice(root.index)
    }

    //当前离节点最近的展开节点
    function nearestExpandedNode(isDown){
        var nodes = upNodes()
        if(isDown) nodes = downNodes()
        for(var i=0; i < nodes.length; i++){
            if(nodes[i].current) return nodes[i]
        }
    }


    ColumnLayout {
        id: clayout
        anchors.fill: parent
        spacing: 0
        
        Rectangle {
            id: handle
            Layout.alignment: Qt.AlignTop
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


                        var nodes = downNodes()
                        if(offsetY < 0){
                            nodes = upNodes()
                        }

                        var nearestUpNode = nearestExpandedNode(false)
                        var nearestDownNode = nearestExpandedNode(true)

                        console.log("nodes.length:" + nodes.length)

                        for(var i = 0; i < nodes.length; i++){
                            var node = nodes[i]
                            console.log(node.title)
                            if(node.canZoomout){
                                var itemOffset = dragZoomOutItem(offsetY, node)
                                if(offsetY > 0){
                                    nearestUpNode.Layout.preferredHeight += itemOffset    
                                }else{
                                    root.y += itemOffset
                                    nearestDownNode.Layout.preferredHeight += Math.abs(itemOffset)
                                }
                                
                                if(Math.abs(offsetY) < Math.abs(itemOffset)){
                                    offsetY -= itemOffset
                                }else{
                                    return
                                }
                            }
                        }

                    }
                }
            }
        }

        Rectangle {
            id: bar
            Layout.alignment: Qt.AlignTop
            Layout.topMargin: 0
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
                    clickZoomItem()
                }
            }
        }

        Rectangle {
            id: container
            Layout.alignment: Qt.AlignTop
            property bool enableBehavior: false
            Layout.fillWidth: true
            Layout.minimumHeight: 0
            Layout.maximumHeight: 99999
            Layout.preferredHeight: current ? root.height - root.fixedHeight : 0
            Layout.fillHeight: current
            clip: true
            
            // Behavior on implicitHeight {
            //     enabled: container.enableBehavior
            //     PropertyAnimation { duration: 200 }
            // }
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

            console.log(node.title + " height: " + node.height)

            nodeIndex++
        }
        console.log("parent.height: " + root.parent.height)
    }

    onHeightChanged:{
        if(height > expandMinimumHeight){
            preservedHeight = height
        }
    }

    // Behavior on y {
    //     enabled: container.enableBehavior
    //     PropertyAnimation { duration: 200 }
    // }




    
}
