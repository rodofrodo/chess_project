import QtQuick
import QtQuick.Controls

Item {
    id: historyPanel
    width: 400
    height: 600

    property bool isWhiteTurn: boardModel.isWhiteTurn

    FontLoader {
        id: productSansBold
        source: "../assets/product-sans-bold.ttf"
    }

    Rectangle { // white/black moves
        id: turnIndicator
        width: 240
        height: 50
        radius: 25
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        
        color: historyPanel.isWhiteTurn ? "white" : "#0f0f0f"
        border.width: 0
        
        Behavior on color { ColorAnimation { duration: 300 } }

        Text {
            text: historyPanel.isWhiteTurn ? "White Moves" : "Black Moves"
            color: historyPanel.isWhiteTurn ? "black" : "white"
            font.family: productSansBold.name
            font.pixelSize: 22
            font.bold: true
            anchors.centerIn: parent

            Behavior on color { ColorAnimation { duration: 300 } }
        }
    }

    // background
    Rectangle {
        id: backgroundBox
        anchors.top: turnIndicator.bottom
        anchors.topMargin: 30
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottomMargin: 80
        color: "#161616"
        radius: 15

        ListView {
            id: moveList
            anchors.fill: parent
            anchors.margins: 15
            spacing: 4
            clip: true

            onCountChanged: {
                moveList.positionViewAtEnd() // automatically scroll to the bottom when a new move is added
            }

            model: boardModel.moveHistoryList

            delegate: Rectangle {
                width: moveList.width
                height: 40
                radius: 8
                
                // different row colors for better readability
                color: index % 2 === 0 ? "#262626" : "#1a1a1a"

                Row {
                    anchors.fill: parent
                    anchors.leftMargin: 20
                    anchors.rightMargin: 20
                    spacing: 30

                    Text { // move number
                        text: (index + 1) + "."
                        color: "#888888"
                        font.family: "Lucida Console"
                        font.pixelSize: 18
                        width: 40
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Text { // white move
                        text: modelData.whiteMove
                        color: "#d4d4d4"
                        font.family: productSansBold.name
                        font.pixelSize: 18
                        width: 80
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Text { // black move
                        text: modelData.blackMove ? modelData.blackMove : ""
                        color: "#888888"
                        font.family: productSansBold.name
                        font.pixelSize: 18
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }

            ScrollBar.vertical: ScrollBar {
                id: vbar
                active: true
                
                contentItem: Rectangle {
                    implicitWidth: 6
                    implicitHeight: 100
                    radius: width / 2
                    color: vbar.pressed ? "#888888" : "#444444"
                }
            }
        }
    }
}
