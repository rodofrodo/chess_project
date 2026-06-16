import QtQuick

Grid {
    id: capturedRoot
    
    spacing: 5

    flow: Grid.TopToBottom 
    
    rows: 8 
    
    layoutDirection: Qt.RightToLeft 

    property string pieceColor: "white"
    property var capturedList: []

   Repeater {
        model: capturedRoot.capturedList
        
        delegate: Item {
            width: 36
            height: 36
            
            Image {
                property real scaleMultiplier: {
                    if (modelData === "rook") return 0.75;
                    return 1.0;
                }
                
                width: parent.width * scaleMultiplier
                height: parent.height * scaleMultiplier
                
                anchors.centerIn: parent 
                
                fillMode: Image.PreserveAspectFit
                
                sourceSize.height: height
                sourceSize.width: width
                
                source: "../assets/pawns/" + modelData + "_" + capturedRoot.pieceColor + ".svg"
                
                opacity: 0.0
                Component.onCompleted: opacity = 1.0
                Behavior on opacity { NumberAnimation { duration: 300 } }
            }
        }
    }
}
