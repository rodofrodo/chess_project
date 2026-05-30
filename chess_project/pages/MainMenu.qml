import QtQuick
import QtQuick.Controls
import "../elements" 

Page {
    id: mainmenu

    FontLoader {
        id: productSansBold
        source: "../assets/product-sans-bold.ttf"
    }

    Image {
        anchors.fill: parent
        source: "../assets/mainmenu_bg.png" 
        fillMode: Image.PreserveAspectCrop
    }

    ChessStartText {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.topMargin: 210
        anchors.leftMargin: 210
    }

    MenuButton {
        text: "PLAY"
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: 565
        anchors.rightMargin: 83
        onClicked: {
            // Navigate to the Play page
            //mainStackView.push(playPage)
        }
    }
    
    MenuButton {
        text: "CREDITS"
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: 711
        anchors.rightMargin: 83
        onClicked: {
            mainmenu.StackView.view.push("CreditsPage.qml")
        }
    }
    
    MenuButton {
        text: "EXIT"
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: 857
        anchors.rightMargin: 83
        onClicked: {
            Qt.quit() // Exit the application
        }
    }
}
