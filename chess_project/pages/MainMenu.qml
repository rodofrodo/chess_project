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
}
