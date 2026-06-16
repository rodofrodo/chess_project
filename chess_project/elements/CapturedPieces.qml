import QtQuick

Grid {
    id: capturedRoot
    
    // We remove the fixed `width: 30` here! 
    // The Grid needs to be able to dynamically expand its width when the 2nd column spawns.
    
    spacing: 5

    // ==========================================
    // THE WRAP LOGIC
    // ==========================================
    // Fill vertically first (like a column), rather than horizontally
    flow: Grid.TopToBottom 
    
    // Stop at 8 items, then wrap to a new column
    rows: 8 
    
    // Force the first column to stay on the right (closest to the board),
    // and make the second column spawn to the LEFT!
    layoutDirection: Qt.RightToLeft 
    // ==========================================

    property string pieceColor: "white"
    property var capturedList: []

   Repeater {
        model: capturedRoot.capturedList
        
        // 1. The Invisible Grid Cell (Keeps spacing perfect)
        delegate: Item {
            width: 36
            height: 36
            
            Image {
                // 2. THE CUSTOM SCALE LOGIC
                // If the piece is a rook, shrink it to 80%. Otherwise, leave it at 100%.
                property real scaleMultiplier: {
                    if (modelData === "rook") return 0.75;
                    return 1.0; // Everything else
                }
                
                width: parent.width * scaleMultiplier
                height: parent.height * scaleMultiplier
                
                // Center the piece inside the invisible 36x36 box
                anchors.centerIn: parent 
                
                fillMode: Image.PreserveAspectFit
                
                // Keeps the SVG crisp at the new smaller size
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
