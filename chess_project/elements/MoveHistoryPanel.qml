import QtQuick
import QtQuick.Controls // Required for the ScrollBar

Item {
    id: historyPanel
    width: 400
    height: 600 // Adjust this to fit nicely next to your board

    // Property synchronized with the backend game model
    property bool isWhiteTurn: boardModel.isWhiteTurn

    FontLoader {
        id: productSansBold
        source: "../assets/product-sans-bold.ttf"
    }

    // ==========================================
    // 1. TURN INDICATOR (The Top Pill)
    // ==========================================
    Rectangle {
        id: turnIndicator
        width: 240
        height: 50
        radius: 25
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        
        // Dynamically invert colors based on whose turn it is
        color: historyPanel.isWhiteTurn ? "white" : "#0f0f0f"
        border.width: 0
        
        Behavior on color { ColorAnimation { duration: 300 } }

        Text {
            text: historyPanel.isWhiteTurn ? "White Moves" : "Black Moves"
            color: historyPanel.isWhiteTurn ? "black" : "white"
            font.family: productSansBold.name
            font.pixelSize: 22
            font.bold: true
            anchors.centerIn: parent

            Behavior on color { ColorAnimation { duration: 300 } }
        }


    }

    // ==========================================
    // 2. MAIN CONTAINER
    // ==========================================
    Rectangle {
        id: backgroundBox
        anchors.top: turnIndicator.bottom
        anchors.topMargin: 30
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        color: "#161616" // Very dark grey background
        radius: 15

        // ==========================================
        // 3. THE SCROLLING LIST
        // ==========================================
        ListView {
            id: moveList
            anchors.fill: parent
            anchors.margins: 15
            spacing: 4
            clip: true // VERY IMPORTANT: Prevents items from scrolling outside the rounded box

            // ==========================================
            // --- ADD THIS AUTO-SCROLL LOGIC HERE ---
            // ==========================================
            onCountChanged: {
                // Whenever a new move is added to the count, instantly snap to the bottom
                moveList.positionViewAtEnd()
            }

            model: boardModel.moveHistoryList

            delegate: Rectangle {
                width: moveList.width
                height: 40
                radius: 8
                
                // Alternating row colors (Darker vs slightly lighter)
                color: index % 2 === 0 ? "#262626" : "#1a1a1a"

                Row {
                    anchors.fill: parent
                    anchors.leftMargin: 20
                    anchors.rightMargin: 20
                    spacing: 30

                    // The Index (1. 2. 3.)
                    Text {
                        text: (index + 1) + "."
                        color: "#888888"
                        font.family: "Lucida Console"
                        font.pixelSize: 18
                        width: 40 // Fixed width ensures the moves perfectly align in a column
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    // White's Move
                    Text {
                        text: modelData.whiteMove
                        color: "#d4d4d4" // Slightly brighter than black's text
                        font.family: productSansBold.name
                        font.pixelSize: 18
                        width: 80 // Fixed width keeps Black's moves perfectly aligned
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    // Black's Move
                    Text {
                        // If black hasn't moved yet on this turn, show nothing
                        text: modelData.blackMove ? modelData.blackMove : ""
                        color: "#888888"
                        font.family: productSansBold.name
                        font.pixelSize: 18
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }

            // ==========================================
            // 4. CUSTOM SCROLLBAR
            // ==========================================
            ScrollBar.vertical: ScrollBar {
                id: vbar
                active: true // Set to false if you want it to auto-hide when not scrolling
                
                // This replaces the default ugly Windows/Mac scrollbar with a sleek pill
                contentItem: Rectangle {
                    implicitWidth: 6
                    implicitHeight: 100
                    radius: width / 2
                    color: vbar.pressed ? "#888888" : "#444444"
                }
            }
        }
    }
}
