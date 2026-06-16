import QtQuick

Rectangle {
    id: timerContainer
    width: 165
    height: 55
    radius: 15
    color: isDark ? "#191717" : "#ffffff"
    
    property bool isDark: true
    property string timeText: "00:00"
    property int rotationAngle: 0

    onTimeTextChanged: {
        timerContainer.rotationAngle += 90;
    }

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
    
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.verticalCenter: parent.verticalCenter

        Rectangle {
            anchors.fill: parent
            radius: width / 2
            border.width: 4
            border.color: isDark ? "#ffffff" : "#000000"
            color: "transparent"
        }

        Rectangle {
            id: clockHand
            width: 4
            height: 10
            color: isDark ? "#ffffff" : "#000000"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 18
            
            transformOrigin: Item.Top
            rotation: timerContainer.rotationAngle
            
            Behavior on rotation {
                RotationAnimator { duration: 500; easing.type: Easing.OutBack }
            }
        }
    }

    Text {
        text: timerContainer.timeText
        font.family: productSansBold.name
        font.pixelSize: 32
        font.bold: true
        color: isDark ? "#ffffff" : "#000000"
    
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.verticalCenter: parent.verticalCenter
    
        horizontalAlignment: Text.AlignRight
    }


}
