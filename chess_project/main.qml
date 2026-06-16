import QtQuick
import QtQuick.Controls

Window {
    id: mainWindow
    width: 1280
    height: 720
    visible: true
    title: qsTr("Chess Game")
    color: "black"
    visibility: Window.FullScreen

    Shortcut {
        sequence: "F11"
        onActivated: {
            if (mainWindow.visibility === Window.FullScreen) {
                mainWindow.showNormal()
            } else {
                mainWindow.showFullScreen()
            }
        }
    }

    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: "pages/StartPage.qml" //
        //initialItem: "pages/GamePage.qml"
    }
}
