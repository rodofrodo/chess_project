import QtQuick

Column {
    id: capturedRoot
    width: 30
    
    // Tightly pack the pieces. You can even use a negative number like -5 
    // to make them overlap slightly if the column gets too long!
    spacing: -8 

    // The color of the pieces in this specific column ("white" or "black")
    property string pieceColor: "white"

    // A list of pieces to display. 
    // Later, C++ will provide this list dynamically!
    property var capturedList: []

    Repeater {
        model: capturedRoot.capturedList
        
        delegate: Image {
            width: 25
            height: 25
            fillMode: Image.PreserveAspectFit
            
            // Dynamically load the image based on the array data and color property
            source: "../assets/pawns/" + modelData + "_" + capturedRoot.pieceColor + ".svg"
            
            // A subtle fade-in effect when a new piece gets captured
            opacity: 0.0
            Component.onCompleted: opacity = 1.0
            Behavior on opacity { NumberAnimation { duration: 300 } }
        }
    }
}
