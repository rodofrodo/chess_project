import QtQuick
import QtQuick.Controls
import "../elements" 

Page {
    id: root
    
    // Load your exact Figma artwork
    Image {
        anchors.fill: parent
        source: "../assets/startpage_bg.png" 
        fillMode: Image.PreserveAspectCrop
    }

    // Native text (crisp, clean, and dynamic)
    ChessStartText {
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -50 
    }
    
    // Add the subtitle (matching your Figma design)
    Text {
        text: "Where every move is a question, and\nevery mistake becomes history."
        color: "#a0a0a0" // A nice subtle grey
        font.pixelSize: 16
        horizontalAlignment: Text.AlignHCenter
        anchors.top: parent.top
        anchors.topMargin: parent.height / 2 + 50 // Positioned under the main title
        anchors.horizontalCenter: parent.horizontalCenter
    }

    // Interactive button
    GetStartedBtn {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 100 
    }
}
