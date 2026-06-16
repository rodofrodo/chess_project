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
        currentIndex: 0 // 0 = Menu, 1 = Game History
        
        // We put the anchors on the Stack itself so it holds the space
        anchors.right: parent.right        
        anchors.rightMargin: 50        
        anchors.left: board.right        
        anchors.leftMargin: 50        
        anchors.top: parent.top        
        anchors.topMargin: 50
        // We must anchor the bottom too, otherwise the history list won't know how far to scroll!
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 50

        // CARD 0: The Setup Menu
        TimeControlMenu {        
            // No anchors needed here, the StackLayout handles it automatically
            
            onStartClicked: (category, timeControl) => {
                console.log("Starting a game of type: " + category + " with time: " + timeControl);
            
                // 1. Tell the C++ backend to configure the game timers based on the selection
                boardModel.startGame(timeControl); 
            
                // 2. Flip the UI to the actual game history panel
                rightPanelStack.currentIndex = 1; 
            }
        }

        // CARD 1: The Active Game History
        MoveHistoryPanel {
            id: historyPanel
            // No anchors needed here either!
        }
    }

    // TOP CAPTURED PIECES (White pieces captured by the top player)
    CapturedPieces {
        id: topCaptured
        anchors.right: board.left
        anchors.rightMargin: 20
        anchors.top: blackTimer.bottom
        anchors.topMargin: 15
        pieceColor: "white"
        
        capturedList: boardModel.blackCapturedList
    }

    // BOTTOM CAPTURED PIECES (Black pieces captured by the bottom player)
    // Notice we use bottom anchors so they grow upwards towards the board center
    CapturedPieces {
        id: bottomCaptured
        anchors.right: board.left
        anchors.rightMargin: 20
        anchors.bottom: whiteTimer.top
        anchors.bottomMargin: 15
        pieceColor: "black"
        
        capturedList: boardModel.whiteCapturedList
    }

    // ABORT / RESTART BUTTON
    /*
    Rectangle {
        id: restartButton
        width: historyPanel.width
        height: 50
        radius: 15
        color: "#161616" // Matches your dark history panel background
        
        // Anchor it right below your history panel!
        anchors.top: historyPanel.bottom
        anchors.topMargin: 15
        anchors.left: historyPanel.left

        Text {
            text: "Restart Game"
            color: "#FF5555" // A nice warning red
            font.family: productSansBold.name
            font.pixelSize: 18
            font.bold: true
            anchors.centerIn: parent
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            
            hoverEnabled: true
            onEntered: restartButton.color = "#262626"
            onExited: restartButton.color = "#161616"

            onClicked: {
                // Wipes the board and starts fresh instantly
                boardModel.startGame("10|0");
            }
        }
    }

    // RETURN TO MENU BUTTON
    Rectangle {
        id: menuButton
        width: historyPanel.width
        height: 50
        radius: 15
        color: "#161616" 
        
        // Example: Anchoring it right below the restart button
        anchors.top: restartButton.bottom
        anchors.topMargin: 10
        anchors.left: historyPanel.left

        Text {
            text: "Main Menu"
            color: "#FFFFFF" 
            font.family: productSansBold.name // Or "Arial"
            font.pixelSize: 18
            font.bold: true
            anchors.centerIn: parent
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            
            hoverEnabled: true
            onEntered: menuButton.color = "#262626"
            onExited: menuButton.color = "#161616"

            onClicked: {
                // 1. Tell C++ to kill the game and timers immediately
                boardModel.stopGame();
                
                // 2. Tell the StackView to destroy this GamePage and go back!
                // (Assuming your StackView id is 'stackView' or similar)
                // If your StackView doesn't have an ID, you can use 'StackView.view'
                gamepage.StackView.view.pop();
            }
        }
    }*/
}
