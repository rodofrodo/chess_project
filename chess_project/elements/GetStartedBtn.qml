import QtQuick

Item {
    id: root
    implicitWidth: 200
    implicitHeight: 50

    /*
        this button is exactly the same as GoBackBtn.qml, but something went wrong,
        so ☆*: .｡. o(≧▽≦)o .｡.:*☆
    */

    signal getStartedClicked()

    FontLoader {
        id: productSansBold
        source: "../assets/product-sans-bold.ttf"
    }

    Rectangle {
        id: bgRect
        anchors.fill: parent
        color: "white"
        radius: height / 2

        scale: mouseArea.pressed ? 0.95 : 1.0
        opacity: mouseArea.containsMouse ? 0.8 : 1.0
        
        Behavior on scale { NumberAnimation { duration: 100 } }
        Behavior on opacity { NumberAnimation { duration: 150 } }

        Text {
            text: "Get started"
            color: "black"
            font.family: productSansBold.name

            font.pixelSize: 24
            font.bold: true
            anchors.centerIn: parent
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        
        onClicked: root.getStartedClicked()
    }
}
