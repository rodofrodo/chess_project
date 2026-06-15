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
        
         delegate: Image {
             width: 36
             height: 36
             fillMode: Image.PreserveAspectFit
            
             source: "../assets/pawns/" + modelData + "_" + capturedRoot.pieceColor + ".svg"
            
             opacity: 0.0
             Component.onCompleted: opacity = 1.0
             Behavior on opacity { NumberAnimation { duration: 300 } }
         }
    }
}
