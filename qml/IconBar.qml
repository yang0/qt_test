import QtQuick


Rectangle {
    FontLoader { id: webFont; source: "iconfont.ttf" }
    
    Text { 
        text: {
                if (webFont.status == FontLoader.Ready) "data"
                else if (webFont.status == FontLoader.Loading) "Loading..."
                else if (webFont.status == FontLoader.Error) "Error loading font"
            } 
        font.family: webFont.name
        font.pointSize: 20
        color: 'red'
    }
    
}