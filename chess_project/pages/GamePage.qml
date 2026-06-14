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
        timeText: "0:00"
        rotationAngle: 180
    }

    PlayerTimer {
        id: whiteTimer

        anchors.right: board.left
        anchors.rightMargin: 20
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 65

        isDark: false
        timeText: "0:00"
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
                // gameModel.setTimeControl(timeControl); 
            
                // 2. Flip the UI to the actual game history panel
                rightPanelStack.currentIndex = 1; 
            }
        }

        // CARD 1: The Active Game History
        MoveHistoryPanel {
            // No anchors needed here either!
        }
    }
}
