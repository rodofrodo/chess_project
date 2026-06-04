import QtQuick

Item {
    id: root
    implicitWidth: mainText.implicitWidth
    implicitHeight: mainText.implicitHeight

    property string text: "CHESS"
    property int fontSize: 168

    FontLoader {
        id: productSansBold
        source: "../assets/product-sans-bold.ttf" 
    }

    // --- 1. MAIN CENTER: White (Always Visible) ---
    Text {
        id: mainText
        text: root.text
        font.family: productSansBold.name
        font.pixelSize: root.fontSize
        font.bold: true
        font.letterSpacing: 10
        color: "white"
        anchors.centerIn: parent
    }

    // ==========================================
    // LEFT GLITCH (Fires at 1.0 seconds)
    // ==========================================

    // FAR LEFT: Heavy Blue
    Text {
        id: blueText
        text: root.text
        font.family: productSansBold.name
        font.pixelSize: root.fontSize
        font.bold: true
        font.letterSpacing: 10
        color: "#0000ff" 
        anchors.centerIn: mainText
        z: -2 
        opacity: 0 

        SequentialAnimation {
            loops: Animation.Infinite
            running: true
            
            PauseAnimation { duration: 500 } // Wait 1 second
            
            PropertyAction { target: blueText; property: "opacity"; value: 1.0 }
            NumberAnimation { target: blueText; property: "anchors.horizontalCenterOffset"; to: -10; duration: 40 }
            NumberAnimation { target: blueText; property: "anchors.horizontalCenterOffset"; to: -3; duration: 30 }
            NumberAnimation { target: blueText; property: "anchors.horizontalCenterOffset"; to: -8; duration: 50 }
            NumberAnimation { target: blueText; property: "anchors.horizontalCenterOffset"; to: -4; duration: 30 }
            PropertyAction { target: blueText; property: "opacity"; value: 0.0 }
            PropertyAction { target: blueText; property: "anchors.horizontalCenterOffset"; value: 0 }
            
            PauseAnimation { duration: 1850 } // Wait the remainder of the 4000ms loop
        }
    }

    // INNER LEFT: Light Cyan
    Text {
        id: cyanText
        text: root.text
        font.family: productSansBold.name
        font.pixelSize: root.fontSize
        font.bold: true
        font.letterSpacing: 10
        color: "#00ffff" 
        anchors.centerIn: mainText
        z: -1 
        opacity: 0 

        SequentialAnimation {
            loops: Animation.Infinite
            running: true
            
            PauseAnimation { duration: 520 } // Offset by 20ms so it tears slightly after blue
            
            PropertyAction { target: cyanText; property: "opacity"; value: 1.0 }
            NumberAnimation { target: cyanText; property: "anchors.horizontalCenterOffset"; to: -6; duration: 30 }
            NumberAnimation { target: cyanText; property: "anchors.horizontalCenterOffset"; to: -2; duration: 40 }
            NumberAnimation { target: cyanText; property: "anchors.horizontalCenterOffset"; to: -5; duration: 40 }
            NumberAnimation { target: cyanText; property: "anchors.horizontalCenterOffset"; to: -3; duration: 20 }
            PropertyAction { target: cyanText; property: "opacity"; value: 0.0 }
            PropertyAction { target: cyanText; property: "anchors.horizontalCenterOffset"; value: 0 }
            
            PauseAnimation { duration: 1850 } 
        }
    }

    // ==========================================
    // RIGHT GLITCH (Fires at 3.0 seconds)
    // ==========================================

    // INNER RIGHT: Light Yellow
    Text {
        id: yellowText
        text: root.text
        font.family: productSansBold.name
        font.pixelSize: root.fontSize
        font.bold: true
        font.letterSpacing: 10
        color: "#ffff00" 
        anchors.centerIn: mainText
        z: -1 
        opacity: 0 

        SequentialAnimation {
            loops: Animation.Infinite
            running: true
            
            PauseAnimation { duration: 520 } // Wait 3 seconds
            
            PropertyAction { target: yellowText; property: "opacity"; value: 1.0 }
            NumberAnimation { target: yellowText; property: "anchors.horizontalCenterOffset"; to: 6; duration: 40 }
            NumberAnimation { target: yellowText; property: "anchors.horizontalCenterOffset"; to: 2; duration: 30 }
            NumberAnimation { target: yellowText; property: "anchors.horizontalCenterOffset"; to: 5; duration: 40 }
            NumberAnimation { target: yellowText; property: "anchors.horizontalCenterOffset"; to: 3; duration: 30 }
            PropertyAction { target: yellowText; property: "opacity"; value: 0.0 }
            PropertyAction { target: yellowText; property: "anchors.horizontalCenterOffset"; value: 0 }
            
            PauseAnimation { duration: 1850 } // Wait the remainder of the 4000ms loop
        }
    }

    // FAR RIGHT: Heavy Red
    Text {
        id: redText
        text: root.text
        font.family: productSansBold.name
        font.pixelSize: root.fontSize
        font.bold: true
        font.letterSpacing: 10
        color: "#ff0000" 
        anchors.centerIn: mainText
        z: -2 
        opacity: 0 

        SequentialAnimation {
            loops: Animation.Infinite
            running: true
            
            PauseAnimation { duration: 500 } // Offset by 20ms
            
            PropertyAction { target: redText; property: "opacity"; value: 1.0 }
            NumberAnimation { target: redText; property: "anchors.horizontalCenterOffset"; to: 10; duration: 30 }
            NumberAnimation { target: redText; property: "anchors.horizontalCenterOffset"; to: 3; duration: 50 }
            NumberAnimation { target: redText; property: "anchors.horizontalCenterOffset"; to: 8;  duration: 30 }
            NumberAnimation { target: redText; property: "anchors.horizontalCenterOffset"; to: 4; duration: 40 }
            PropertyAction { target: redText; property: "opacity"; value: 0.0 }
            PropertyAction { target: redText; property: "anchors.horizontalCenterOffset"; value: 0 }
            
            PauseAnimation { duration: 1850 } 
        }
    }
}
