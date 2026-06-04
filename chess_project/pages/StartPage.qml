import QtQuick
import QtQuick.Controls
import "../elements" 

Page {
    id: root
    
    FontLoader {
        id: productSansRegular
        source: "../assets/product-sans-regular.ttf"
    }

    // Load your exact Figma artwork
    Image {
        anchors.fill: parent
        source: "../assets/startpage_bg.png" 
        fillMode: Image.PreserveAspectCrop
    }

    // Native text (crisp, clean, and dynamic)
    ChessStartText {
        id: chessText
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 222
    }
    
    // Add the subtitle (matching your Figma design)
    Text {
        id: chessSubtitle
        text: "Where every move is a question, and\nevery mistake becomes history."
        color: "#a0a0a0" // A nice subtle grey
        font.family: productSansRegular.name

        font.pixelSize: 24
        horizontalAlignment: Text.AlignHCenter
        anchors.top: chessText.bottom
        anchors.topMargin: 45
        anchors.horizontalCenter: parent.horizontalCenter
    }

    // Interactive button
    GetStartedBtn {
        anchors.top: chessSubtitle.bottom
        anchors.topMargin: 210
        anchors.horizontalCenter: parent.horizontalCenter

        onGetStartedClicked: {
            root.StackView.view.push("MainMenu.qml")
        }
    }
}
