import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../elements" 

Page {
    id: gamepage

    background: Rectangle {
        color: "#000" 
    }

    FontLoader {
        id: productSansBold
        source: "../assets/product-sans-bold.ttf"
    }

    FontLoader {
        id: productSansRegular
        source: "../assets/product-sans-regular.ttf"
    }

    ChessBoard {
        id: board
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 220
    }

    PlayerTimer {
        id: blackTimer

        anchors.right: board.left
        anchors.rightMargin: 20
        anchors.top: parent.top
        anchors.topMargin: 65

        isDark: true
        timeText: boardModel.blackTimeText
        rotationAngle: 180
    }

    PlayerTimer {
        id: whiteTimer

        anchors.right: board.left
        anchors.rightMargin: 20
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 65

        isDark: false
        timeText: boardModel.whiteTimeText
        rotationAngle: 180
    }

    StackLayout {
        id: rightPanelStack
        currentIndex: 0
        anchors.right: parent.right        
        anchors.rightMargin: 50        
        anchors.left: board.right        
        anchors.leftMargin: 50        
        anchors.top: parent.top        
        anchors.topMargin: 50
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 50

        TimeControlMenu {
            onStartClicked: (category, timeControl) => {
                console.log("Starting a game of type: " + category + " with time: " + timeControl);
                boardModel.startGame(timeControl); 
                rightPanelStack.currentIndex = 1; 
            }
        }

        MoveHistoryPanel {
            id: historyPanel
        }
    }

    CapturedPieces {
        id: topCaptured
        anchors.right: board.left
        anchors.rightMargin: 20
        anchors.top: blackTimer.bottom
        anchors.topMargin: 15
        pieceColor: "white"
        
        capturedList: boardModel.blackCapturedList
    }

    CapturedPieces {
        id: bottomCaptured
        anchors.right: board.left
        anchors.rightMargin: 20
        anchors.bottom: whiteTimer.top
        anchors.bottomMargin: 15
        pieceColor: "black"
        
        capturedList: boardModel.whiteCapturedList
    }

    // RETURN TO MENU BUTTON
    Rectangle {
        id: menuButton
        width: 200
        height: 50

        anchors.top: restartButton.bottom
        anchors.topMargin: 10
        anchors.left: historyPanel.left

        color: "white"
        radius: height / 2

        scale: mouseArea.pressed ? 0.95 : 1.0
        opacity: mouseArea.containsMouse ? 0.8 : 1.0
    
        Behavior on scale { NumberAnimation { duration: 100 } }
        Behavior on opacity { NumberAnimation { duration: 150 } }

        Text {
            text: "Main Menu"
            color: "black"
            font.family: productSansBold.name
            font.pixelSize: 24
            font.bold: true
            anchors.centerIn: parent
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            hoverEnabled: true

            onClicked: {
                boardModel.stopGame();
                gamepage.StackView.view.pop();
            }
        }
    }
}
