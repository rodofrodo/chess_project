import QtQuick

Rectangle {
    id: timerContainer
    width: 165
    height: 55
    radius: 15
    color: isDark ? "#191717" : "#ffffff"
    
    // Properties to customize the timer
    property bool isDark: true
    property string timeText: "00:00"
    property int rotationAngle: 0 // Change this to 0, 90, 180, or 270

    onTimeTextChanged: {
        timerContainer.rotationAngle += 90;
    }

    //Component.onCompleted: {
        // Force a small delay to ensure the rotation is detected as a "change"
        //timerContainer.rotationAngle = 0; 
    //}

    FontLoader {
        id: productSansBold
        source: "../assets/product-sans-bold.ttf"
    }

    FontLoader {
        id: productSansRegular
        source: "../assets/product-sans-regular.ttf"
    }

    Item {
        width: 36
        height: 36
    
        // Anchor strictly to the left wall of the parent
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.verticalCenter: parent.verticalCenter

        // The Circle (The clock face)
        Rectangle {
            anchors.fill: parent
            radius: width / 2
            border.width: 4
            border.color: isDark ? "#ffffff" : "#000000"
            color: "transparent"
        }

        // The "Moving Line" (The clock hand)
        Rectangle {
            id: clockHand
            width: 4
            height: 10
            color: isDark ? "#ffffff" : "#000000"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 18
            
            // This is the "magic" that makes the line rotate around the center
            transformOrigin: Item.Top
            rotation: timerContainer.rotationAngle
            
            // Smooth animation for the rotation
            Behavior on rotation {
                RotationAnimator { duration: 500; easing.type: Easing.OutBack }
            }
        }
    }

    // 2. The Time Text
    Text {
        text: timerContainer.timeText
        font.family: productSansBold.name
        font.pixelSize: 32
        font.bold: true
        color: isDark ? "#ffffff" : "#000000"
    
        // Anchor strictly to the right wall of the parent
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.verticalCenter: parent.verticalCenter
    
        // Optional but helpful: forces the text to grow leftward instead of rightward
        horizontalAlignment: Text.AlignRight
    }


}
