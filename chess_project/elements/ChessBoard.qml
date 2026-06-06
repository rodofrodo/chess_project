import QtQuick

// The outer white border with rounded corners
Rectangle {
    id: root
    width: 970
    height: 970
    color: "white" 
    radius: 25

    function getPieceName(type, color) {
        if (type === -1) return "";
        var types = ["pawn", "rook", "knight", "bishop", "queen", "king"];
        var colors = ["white", "black"];
        return types[type] + "_" + colors[color];
    }

    Rectangle {
        anchors.centerIn: parent
        
        // Make it exactly 2 pixels larger than the grid to hold the 1px border!
        width: 890 
        height: 890
        
        color: "transparent" // The inside is empty so we see the board
        border.color: "black"
        border.width: 1
    }

    // The actual 8x8 playing grid
    Grid {
        id: boardGrid
        columns: 8
        rows: 8
        anchors.centerIn: parent
        
        // We make the grid slightly smaller than the background to leave a white border
        width: 888
        height: 888

        Repeater {
            model: boardModel

            delegate: Rectangle {
                id: tile
                // Each tile is exactly 1/8th of the total grid size
                width: boardGrid.width / 8
                height: boardGrid.height / 8
                
                // Calculate the row and col based on the 0-63 index
                property int row: Math.floor(index / 8)
                property int col: index % 8
                property bool isLightSquare: (row + col) % 2 === 0
                
                // If row + col is even, it's white. If odd, it's black.
                color: {
                    if (model.isHighlighted) {
                        // The Highlight Colors
                        return isLightSquare ? "#f4f680" : "#baca44" 
                    } else {
                        // The Normal Board Colors (from your screenshots!)
                        return isLightSquare ? "#ebecd0" : "#779556" 
                    }
                }

                z: 0 // Simplification since drag/drop is removed

                // --- ADD THE PIECE IMAGE HERE ---
                Image {
                    id: pieceImage
                    
                    // Make the piece slightly smaller than the tile so it breathes
                    width: parent.width * 0.65
                    height: parent.height * 0.65
                    fillMode: Image.PreserveAspectFit
                    anchors.centerIn: parent
                    
                    // The Magic Logic: What piece goes here?
                    property string pieceName: root.getPieceName(model.pieceType, model.pieceColor)
                    source: pieceName !== "" ? "../assets/pawns/" + pieceName + ".png" : ""
                    visible: pieceName !== ""
                }

                MouseArea {
                    id: clickArea                    
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    
                    onClicked: {
                        boardModel.selectSquare(index);
                    }
                }
            }
        }
    }

    // ==========================================
    // TOP LETTERS (A - H)
    // ==========================================
    Row {
        anchors.bottom: boardGrid.top
        anchors.left: boardGrid.left
        height: 41 // Fills your exact border gap!
        
        Repeater {
            model: ["A", "B", "C", "D", "E", "F", "G", "H"]
            
            Item {
                width: boardGrid.width / 8
                height: parent.height
                
                Text {
                    text: modelData // modelData magically pulls the string from the array!
                    font.family: "Arial"
                    font.pixelSize: 16
                    font.bold: true
                    color: "black"
                    anchors.centerIn: parent
                }
            }
        }
    }

    // ==========================================
    // BOTTOM LETTERS (A - H)
    // ==========================================
    Row {
        anchors.top: boardGrid.bottom
        anchors.left: boardGrid.left
        height: 41
        
        Repeater {
            model: ["A", "B", "C", "D", "E", "F", "G", "H"]
            Item {
                width: boardGrid.width / 8
                height: parent.height
                Text {
                    text: modelData
                    font.family: "Arial"
                    font.pixelSize: 16
                    font.bold: true
                    color: "black"
                    anchors.centerIn: parent
                }
            }
        }
    }

    // ==========================================
    // LEFT NUMBERS (8 - 1)
    // ==========================================
    Column {
        anchors.right: boardGrid.left
        anchors.top: boardGrid.top
        width: 41
        
        Repeater {
            model: ["8", "7", "6", "5", "4", "3", "2", "1"] // Remember, White is at the bottom, so 8 is at the top!
            Item {
                width: parent.width
                height: boardGrid.height / 8
                Text {
                    text: modelData
                    font.family: "Arial"
                    font.pixelSize: 16
                    font.bold: true
                    color: "black"
                    anchors.centerIn: parent
                }
            }
        }
    }

    // ==========================================
    // RIGHT NUMBERS (8 - 1)
    // ==========================================
    Column {
        anchors.left: boardGrid.right
        anchors.top: boardGrid.top
        width: 41
        
        Repeater {
            model: ["8", "7", "6", "5", "4", "3", "2", "1"]
            Item {
                width: parent.width
                height: boardGrid.height / 8
                Text {
                    text: modelData
                    font.family: "Arial"
                    font.pixelSize: 16
                    font.bold: true
                    color: "black"
                    anchors.centerIn: parent
                }
            }
        }
    }
}
