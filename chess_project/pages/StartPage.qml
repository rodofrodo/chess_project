import QtQuick
import QtQuick.Controls

Page {
    id: root
    background: Rectangle { color: "black" } // Match your Figma background

    // ... All your text and glitch effects go here ...

    Button {
        text: "Get started"
        anchors.centerIn: parent
        
        onClicked: {
            // StackView is an "attached property". 
            // Any component inside a StackView can access the stack to navigate!
            //StackView.view.push("GamePage.qml")
        }
    }
}
