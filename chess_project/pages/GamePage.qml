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

        onReturnToMenu: { // custom signal from ChessBoard
            gamepage.StackView.view.pop(); 
            gamepage.StackView.view.push("GamePage.qml");
        }
    }

    // player timer controls
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

    /*
        so I used StackLayout here because I wanted to have a menu on the right side 
        of the board that can switch between different panels.
    */
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
                console.log("Starting a game of type: " + category + " with time: " + timeControl); // test
                boardModel.startGame(timeControl); 
                rightPanelStack.currentIndex = 1; 
            }
        }

        MoveHistoryPanel {
            id: historyPanel
            visible: rightPanelStack.currentIndex == 1 // pretty cool, right?
        }
    }

    CapturedPieces {
        id: topCaptured
        anchors.right: board.left
        anchors.rightMargin: 20
        anchors.top: blackTimer.bottom
        anchors.topMargin: 15
        pieceColor: "white" // because there are pieces captured by black, so they are white pieces
        
        capturedList: boardModel.blackCapturedList
    }

    CapturedPieces {
        id: bottomCaptured
        anchors.right: board.left
        anchors.rightMargin: 20
        anchors.bottom: whiteTimer.top
        anchors.bottomMargin: 15
        pieceColor: "black" // same story here
        
        capturedList: boardModel.whiteCapturedList
    }

    // RETURN TO MENU BUTTON
    Item {
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 45
    
        anchors.left: board.right 
        anchors.leftMargin: 20
        anchors.right: parent.right
        anchors.rightMargin: 20
    
        height: 50
        visible: rightPanelStack.currentIndex == 1

        Rectangle {
            id: menuButton
            width: 200
            height: 50

            anchors.centerIn: parent

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
                    boardModel.stopGame(); // stop the game when returning to menu
                    gamepage.StackView.view.pop();
                }
            }
        }
    }
}
