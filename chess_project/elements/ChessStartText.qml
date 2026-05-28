import QtQuick

Item {
    id: root
    implicitWidth: mainText.implicitWidth
    implicitHeight: mainText.implicitHeight

    property string text: "CHESS"

    FontLoader {
        id: productSansBold
        source: "../assets/product-sans-bold.ttf" 
    }

    // 1. Main white layer (Always visible)
    Text {
        id: mainText
        text: root.text
        font.family: productSansBold.name

        font.pixelSize: 168
        font.bold: true
        font.letterSpacing: 10
        color: "white"
        anchors.centerIn: parent
    }

    // 2. Cyan (Blue) layer
    Text {
        id: cyanText
        text: root.text
        font.family: productSansBold.name

        font.pixelSize: 168
        font.bold: true
        font.letterSpacing: 10
        color: "#00f0ff"
        anchors.centerIn: mainText
        z: -1 
        opacity: 0 // Default to invisible!

        SequentialAnimation {
            loops: Animation.Infinite
            running: true
            
            // 1. Long period of normalcy
            PauseAnimation { duration: 3000 }
            
            // 2. SNAP to visible
            PropertyAction { target: cyanText; property: "opacity"; value: 1.0 }
            
            // 3. Jitter around rapidly
            NumberAnimation { target: cyanText; property: "anchors.horizontalCenterOffset"; to: -10; duration: 40 }
            NumberAnimation { target: cyanText; property: "anchors.horizontalCenterOffset"; to: 2; duration: 30 }
            NumberAnimation { target: cyanText; property: "anchors.horizontalCenterOffset"; to: -8; duration: 50 }
            NumberAnimation { target: cyanText; property: "anchors.horizontalCenterOffset"; to: -4; duration: 30 }
            
            // 4. SNAP back to invisible and reset position
            PropertyAction { target: cyanText; property: "opacity"; value: 0.0 }
            PropertyAction { target: cyanText; property: "anchors.horizontalCenterOffset"; value: 0 }
        }
    }

    // 3. Red layer
    Text {
        id: redText
        text: root.text
        font.family: productSansBold.name

        font.pixelSize: 168
        font.bold: true
        font.letterSpacing: 10
        color: "#ff003c"
        anchors.centerIn: mainText
        z: -1 
        opacity: 0 // Default to invisible!

        SequentialAnimation {
            loops: Animation.Infinite
            running: true
            
            // Slightly offset pause so it feels chaotic and organic
            PauseAnimation { duration: 3150 }
            
            PropertyAction { target: redText; property: "opacity"; value: 1.0 }
            
            NumberAnimation { target: redText; property: "anchors.horizontalCenterOffset"; to: 8; duration: 30 }
            NumberAnimation { target: redText; property: "anchors.horizontalCenterOffset"; to: -2; duration: 50 }
            NumberAnimation { target: redText; property: "anchors.horizontalCenterOffset"; to: 9; duration: 40 }
            NumberAnimation { target: redText; property: "anchors.horizontalCenterOffset"; to: 4; duration: 30 }
            
            PropertyAction { target: redText; property: "opacity"; value: 0.0 }
            PropertyAction { target: redText; property: "anchors.horizontalCenterOffset"; value: 0 }
        }
    }
}
