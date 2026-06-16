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

    Shape {
        id: hoverBg
        anchors.fill: parent
        opacity: mouseArea.containsMouse ? 1.0 : 0.0 
        Behavior on opacity { NumberAnimation { duration: 150 } }

        ShapePath {
            fillColor: "#ff00ff"
            strokeColor: "transparent"
            
            startX: 20; startY: 0
            PathLine { x: root.width; y: 0 }
            PathLine { x: root.width - 20; y: root.height }
            PathLine { x: 0; y: root.height }
            PathLine { x: 20; y: 0 }
        }
    }

    Text {
        text: root.text
        color: "#00ffff"
        font.family: productSansBold.name
        font.pixelSize: 64
        font.bold: true
        font.letterSpacing: 6
        
        anchors.centerIn: parent
        anchors.horizontalCenterOffset: -3
        anchors.verticalCenterOffset: 2
        
        opacity: mouseArea.containsMouse ? 1.0 : 0.0
        Behavior on opacity { NumberAnimation { duration: 100 } }
    }

    Text {
        id: mainText
        text: root.text
        
        color: mouseArea.containsMouse ? "black" : "white" 
        
        font.family: productSansBold.name
        font.pixelSize: 64
        font.bold: true
        font.letterSpacing: 6
        anchors.centerIn: parent
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true 
        cursorShape: Qt.PointingHandCursor 
        onClicked: root.clicked()
    }
}
