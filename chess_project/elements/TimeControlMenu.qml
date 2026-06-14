import QtQuick

Item {
    id: menuRoot
    // Give the menu a default size, though the GamePage will position it
    width: 400
    height: 500

    // This signal will let the GamePage know when the user is ready to play!
    signal continueClicked(int selectedIndex, string selectedText)

    // Keeps track of which option the user has clicked
    property int selectedIndex: 0

    // The data model for our menu options
    property var options: [
        "CLASSICAL [>60 min]",
        "RAPID [10-60 min]",
        "BLITZ [3-10 min]",
        "BULLET [<3 min]" // <-- Fixed the typo here!
    ]

    FontLoader {
        id: productSansBold
        source: "../assets/product-sans-bold.ttf"
    }

    FontLoader {
        id: productSansRegular
        source: "../assets/product-sans-regular.ttf"
    }

    Column {
        anchors.centerIn: parent
        spacing: 30
        width: 500 // This controls how wide the blue highlight bar gets

        // 1. The Header
        Text {
            text: "Choose a time control"
            color: "white"
            font.family: productSansBold.name
            font.pixelSize: 48
            font.bold: true
            anchors.horizontalCenter: parent.horizontalCenter
        }

        // Add a little extra gap between the header and the list
        Item { width: 1; height: 10 }

        // 2. The Interactive List
        Column {
            width: parent.width
            spacing: 15

            Repeater {
                model: menuRoot.options

                delegate: Rectangle {
                    width: parent.width
                    height: 45
                    // If this is the selected index, make the background bright blue
                    color: menuRoot.selectedIndex === index ? "#0000ff" : "transparent"

                    Text {
                        text: modelData
                        // If selected, make text cyan. If not, make it white.
                        color: menuRoot.selectedIndex === index ? "#00ffff" : "white"
                        // Using a monospace font gives it that authentic digital look
                        font.family: "Lucida Console" 
                        font.pixelSize: 36
                        anchors.centerIn: parent
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            menuRoot.selectedIndex = index;
                        }
                    }
                }
            }
        }

        // Add a gap before the button
        Item { width: 1; height: 30 }

        // 3. The Continue Button
        /*
        Rectangle {
            width: 160
            height: 45
            radius: 22.5 // Exactly half the height to make it a perfect "pill" shape
            color: "white"
            anchors.horizontalCenter: parent.horizontalCenter

            Text {
                text: "Continue"
                color: "black"
                font.family: "Arial"
                font.pixelSize: 18
                font.bold: true
                anchors.centerIn: parent
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                
                // Add a tiny visual click effect
                onPressed: parent.scale = 0.95
                onReleased: parent.scale = 1.0
                
                onClicked: {
                    // Fire the signal so the parent GamePage can swap the UI
                    menuRoot.continueClicked(menuRoot.selectedIndex, menuRoot.options[menuRoot.selectedIndex])
                }
            }*/
        Rectangle {
            id: bgRect
            width: 200            
            height: 50
            anchors.horizontalCenter: parent.horizontalCenter
            color: "white"
            radius: height / 2

            // A beautiful, smooth press and hover effect
            scale: mouseArea.pressed ? 0.95 : 1.0
            opacity: mouseArea.containsMouse ? 0.8 : 1.0
        
            Behavior on scale { NumberAnimation { duration: 100 } }
            Behavior on opacity { NumberAnimation { duration: 150 } }

            Text {
                text: "Continue"
                color: "black"
                font.family: productSansBold.name

                font.pixelSize: 24
                font.bold: true
                anchors.centerIn: parent
            }

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true

                // Add a tiny visual click effect
                onPressed: parent.scale = 0.95
                onReleased: parent.scale = 1.0
            
                onClicked: {
                    // Fire the signal so the parent GamePage can swap the UI
                    console.log(menuRoot.selectedIndex + "&" + menuRoot.options[menuRoot.selectedIndex]);
                }
            }
        }
    }
}
