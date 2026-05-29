import QtQuick
import QtQuick.Controls

Window {
    id: mainWindow
    width: 1280
    height: 720
    visible: true
    title: qsTr("Chess Game")
    color: "black" // Prevents white flashes during page transitions
    visibility: Window.FullScreen // Start in full-screen mode

    Shortcut {
        sequence: "F11"
        onActivated: {
            if (mainWindow.visibility === Window.FullScreen) {
                mainWindow.showNormal() // Returns to standard windowed mode
            } else {
                mainWindow.showFullScreen() // Expands to cover the whole monitor
            }
        }
    }

    StackView {
        id: stackView
        anchors.fill: parent
        
        // This is the first page the app loads
        initialItem: "pages/StartPage.qml" 
    }
}
