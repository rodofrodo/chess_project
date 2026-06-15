import QtQuick

Item {
    id: menuRoot
    width: 400
    height: 500

    // The final signal that tells GamePage to start the clocks!
    signal startClicked(string category, string timeControl)

    // STATE TRACKING
    // 0 = Showing Categories (Rapid, Blitz, etc)
    // 1 = Showing Specific Times (10|0, 5|3, etc)
    property int menuState: 0 
    
    property string selectedCategory: ""
    property int selectedIndex: 0

    // THE MASTER DATA DICTIONARY
    // This defines exactly what options appear for each category!
    property var timeData: {
        "CLASSICAL [>60 min]": ["60 | 0", "90 | 30"],
        "RAPID [10-60 min]": ["10 | 0", "15 | 10", "30 | 0"],
        "BLITZ [3-10 min]": ["3 | 0", "3 | 2", "5 | 0", "5 | 3"],
        "BULLET [<3 min]": ["1 | 0", "1 | 1", "2 | 1"]
    }

    // Helper arrays to feed the Repeater
    property var categories: ["CLASSICAL [>60 min]", "RAPID [10-60 min]", "BLITZ [3-10 min]", "BULLET [<3 min]"]
    
    // The "Magic" variable: It dynamically updates the list based on the state!
    property var currentOptions: menuState === 0 ? categories : timeData[selectedCategory]

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
        spacing: 20
        width: 500

        // ==========================================
        // 1. DYNAMIC HEADER
        // ==========================================
        Text {
            // Changes title based on state
            text: menuState === 0 ? "Choose a time control" : "Choice: " + selectedCategory.split(" ")[0] 
            color: "white"
            font.family: productSansBold.name
            font.pixelSize: menuState === 0 ? 48 : 36
            font.bold: true
            anchors.horizontalCenter: parent.horizontalCenter
        }

        // Back Button (Only visible when picking specific times)
        Text {
            text: "Back to categories"
            color: "#888888"
            font.family: productSansRegular.name
            font.pixelSize: 18
            visible: menuState === 1
            anchors.horizontalCenter: parent.horizontalCenter

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    // Send them back to the main menu
                    menuRoot.menuState = 0;
                    menuRoot.selectedIndex = 0; 
                }
            }
        }

        Item { width: 1; height: 10 } // Spacer

        // ==========================================
        // 2. DYNAMIC LIST
        // ==========================================
        Column {
            width: parent.width
            spacing: 15

            Repeater {
                model: menuRoot.currentOptions
                
                delegate: Rectangle {
                    width: parent.width
                    height: menuRoot.menuState === 0 ? 45 : 40

                    color: (menuRoot.selectedIndex === index && menuRoot.menuState === 0) 
                           ? "#0000ff" 
                           : "transparent"

                    Text {
                        text: modelData
                        
                        // Cyan for main menu selection, Magenta for sub-menu selection!
                        color: menuRoot.selectedIndex === index 
                               ? (menuRoot.menuState === 0 ? "#00ffff" : "#ea00d9") 
                               : "white"
                               
                        // Hacker font for main menu, clean font for sub-menu
                        font.family: menuRoot.menuState === 0 ? "Lucida Console" : productSansRegular.name
                        font.pixelSize: menuRoot.menuState === 0 ? 36 : 32
                        anchors.centerIn: parent
                        
                        Behavior on color { ColorAnimation { duration: 150 } }
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

        Item { width: 1; height: 20 } // Spacer

        // ==========================================
        // 3. MULTI-PURPOSE ACTION BUTTON
        // ==========================================
        Rectangle {
            id: bgRect
            width: 200
            height: 50
            anchors.horizontalCenter: parent.horizontalCenter
            color: "white"
            radius: height / 2

            scale: mouseArea.pressed ? 0.95 : 1.0
            opacity: mouseArea.containsMouse ? 0.8 : 1.0
        
            Behavior on scale { NumberAnimation { duration: 100 } }
            Behavior on opacity { NumberAnimation { duration: 150 } }

            Text {
                // Changes text based on state
                text: menuRoot.menuState === 0 ? "Continue" : "Start"
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

                onClicked: {
                    if (menuRoot.menuState === 0) {
                        // STEP 1: They clicked Continue. 
                        // Save their category, switch to State 1, and reset the list index.
                        menuRoot.selectedCategory = menuRoot.currentOptions[menuRoot.selectedIndex];
                        menuRoot.menuState = 1;
                        menuRoot.selectedIndex = 0; 
                    } else {
                        // STEP 2: They clicked Start.
                        // Fire the signal with their final choices!
                        var finalTime = menuRoot.currentOptions[menuRoot.selectedIndex];
                        console.log("GAME STARTING! Mode: " + menuRoot.selectedCategory + " | Time: " + finalTime);
                        menuRoot.startClicked(menuRoot.selectedCategory, finalTime);
                    }
                }
            }
        }
    }
}
