import QtQuick
import QtQuick.Shapes

Item {
    id: root
    implicitWidth: 477
    implicitHeight: 78

    property string text: "BUTTON"
    signal clicked()

    FontLoader {
        id: productSansBold
        source: "../assets/product-sans-bold.ttf"
    }

    // --- 1. The Slanted Magenta Background ---
    Shape {
        id: hoverBg
        anchors.fill: parent
        // Only visible when hovered!
        opacity: mouseArea.containsMouse ? 1.0 : 0.0 
        Behavior on opacity { NumberAnimation { duration: 150 } }

        ShapePath {
            fillColor: "#ff00ff" // Pure Cyberpunk Magenta
            strokeColor: "transparent"
            
            // Draw the slanted rectangle point by point
            // We use a 20-pixel offset to create the slant
            startX: 20; startY: 0
            PathLine { x: root.width; y: 0 }                 // Top straight edge
            PathLine { x: root.width - 20; y: root.height }  // Right slanted edge
            PathLine { x: 0; y: root.height }                // Bottom straight edge
            PathLine { x: 20; y: 0 }                         // Left slanted edge
        }
    }

    // --- 2. The Cyan Glitch Shadow (Hover Only) ---
    Text {
        text: root.text
        color: "#00ffff" // Cyan
        font.family: productSansBold.name
        font.pixelSize: 64
        font.bold: true
        font.letterSpacing: 6
        
        // Offset slightly to the left and down
        anchors.centerIn: parent
        anchors.horizontalCenterOffset: -3
        anchors.verticalCenterOffset: 2
        
        opacity: mouseArea.containsMouse ? 1.0 : 0.0
        Behavior on opacity { NumberAnimation { duration: 100 } }
    }

    // --- 3. The Main Text ---
    Text {
        id: mainText
        text: root.text
        
        // Turns black on hover, white by default
        color: mouseArea.containsMouse ? "black" : "white" 
        
        font.family: productSansBold.name
        font.pixelSize: 64
        font.bold: true
        font.letterSpacing: 6
        anchors.centerIn: parent
    }

    // --- 4. The Mouse Interaction ---
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true 
        cursorShape: Qt.PointingHandCursor 
        onClicked: root.clicked()
    }
}
