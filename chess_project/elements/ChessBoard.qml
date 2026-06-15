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
                        return isLightSquare ? "#0077EE" : "#004E9C" 
                    } else {
                        // The Normal Board Colors (from your screenshots!)
                        return isLightSquare ? "#FFFFCD" : "#EC94A3" 
                    }
                }

                z: clickArea.drag.active ? 1 : 0 // Ensure the dragged piece is always on top

                // --- ADD THE PIECE IMAGE HERE ---
                Image {
                    id: pieceImage
                    
                    width: implicitWidth
                    height: implicitHeight
                    fillMode: Image.Pad
                    
                    // THE TRUE BLUR FIX: Force integer pixel alignments!
                    // This stops the engine from positioning an SVG at a half-pixel (like 12.5), 
                    // which is what ruins the crisp vector lines.
                    x: clickArea.drag.active ? undefined : Math.floor((parent.width - implicitWidth) / 2)
                    y: clickArea.drag.active ? undefined : Math.floor((parent.height - implicitHeight) / 2)
                    
                    // The Magic Logic: What piece goes here?
                    property string pieceName: root.getPieceName(model.pieceType, model.pieceColor)
                    source: pieceName !== "" ? "../assets/pawns/" + pieceName + ".svg" : ""
                    visible: pieceName !== ""
                }

                MouseArea {
                    id: clickArea
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    
                    drag.target: pieceImage
                    drag.axis: Drag.XAndYAxis
                    
                    // 1. A flag to separate pure clicks from drag-and-drops
                    property bool dragOccurred: false
                    
                    // If the mouse moves while dragging, flip the flag to true
                    onPositionChanged: {
                        if (drag.active) dragOccurred = true;
                    }

                    onPressed: {
                        dragOccurred = false; // Reset flag on every new click
                        
                        // Tell C++ we interacted with this square.
                        // - If it's a click, C++ selects the piece. 
                        // - If it's an empty square, C++ attempts a move!
                        boardModel.selectSquare(index);
                    }

                    onReleased: {
                        // 2. Only run the drop math if they ACTUALLY dragged the piece
                        if (dragOccurred) {
                            var gridPoint = mapToItem(boardGrid, mouseX, mouseY);
                            var targetCol = Math.floor(gridPoint.x / tile.width);
                            var targetRow = Math.floor(gridPoint.y / tile.height);
                            
                            if (targetCol >= 0 && targetCol < 8 && targetRow >= 0 && targetRow < 8) {
                                var targetIndex = (targetRow * 8) + targetCol;
                                
                                // Only trigger the backend if dropped on a DIFFERENT tile
                                if (targetIndex !== index) {
                                    boardModel.selectSquare(targetIndex);
                                }
                            }
                        }
                        
                        // Reset the flag for the next interaction
                        dragOccurred = false; 
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
