import QtQuick

// We use a basic Item as the foundation
Item {
    id: root
    implicitWidth: 200
    implicitHeight: 50

    signal getStartedClicked()

    Rectangle {
        id: bgRect
        anchors.fill: parent
        color: "white"
        radius: height / 2

        // A beautiful, smooth press and hover effect
        scale: mouseArea.pressed ? 0.95 : 1.0
        opacity: mouseArea.containsMouse ? 0.8 : 1.0
        
        Behavior on scale { NumberAnimation { duration: 100 } }
        Behavior on opacity { NumberAnimation { duration: 150 } }

        Text {
            text: "Get started"
            color: "black"
            font.pixelSize: 18
            font.bold: true
            anchors.centerIn: parent
        }
    }

    // MouseArea handles all the click and hover logic transparently
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true // This is required to detect the mouse hovering
        cursorShape: Qt.PointingHandCursor // Changes the mouse to a pointing finger
        
        onClicked: root.getStartedClicked()
    }
}
