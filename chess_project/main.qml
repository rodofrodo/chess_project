import QtQuick
import QtQuick.Controls

Window {
    width: 1280
    height: 720
    visible: true
    title: qsTr("Chess App")
    color: "black" // Prevents white flashes during page transitions

    StackView {
        id: stackView
        anchors.fill: parent
        
        // This is the first page the app loads
        initialItem: "pages/StartPage.qml" 
    }
}
