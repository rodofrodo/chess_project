import QtQuick

// The outer white border with rounded corners
Rectangle {
    id: root
    width: 970
    height: 970
    color: "white" 
    radius: 25

    ListModel {
        id: boardModel
    }

    // Automatically fill the model with the starting chess layout when the app loads
    Component.onCompleted: {
        const backRow = ["rook", "knight", "bishop", "queen", "king", "bishop", "knight", "rook"];
        for (var i = 0; i < 64; i++) {
            var r = Math.floor(i / 8);
            var c = i % 8;
            var name = "";
            
            if (r === 0) name = backRow[c] + "_black";
            else if (r === 1) name = "pawn_black";
            else if (r === 6) name = "pawn_white";
            else if (r === 7) name = backRow[c] + "_white";
            
            boardModel.append({ "pieceName": name });
        }
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

        property int selectedIndex: -1 // No tile is selected by default

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
                property bool isSelected: boardGrid.selectedIndex === index
                
                // If row + col is even, it's white. If odd, it's black.
                color: {
                    if (isSelected) {
                        // The Highlight Colors
                        return isLightSquare ? "#f4f680" : "#baca44" 
                    } else {
                        // The Normal Board Colors (from your screenshots!)
                        return isLightSquare ? "#ebecd0" : "#779556" 
                    }
                }

                z: dragArea.drag.active ? 1 : 0 // Ensure the dragged piece is always on top

                // --- ADD THE PIECE IMAGE HERE ---
                Image {
                    id: pieceImage
                    
                    // Make the piece slightly smaller than the tile so it breathes
                    width: parent.width * 0.65
                    height: parent.height * 0.65
                    fillMode: Image.PreserveAspectFit
                    
                    // The Magic Logic: What piece goes here?
                    // The Magic Logic: What piece goes here?
                    source: model.pieceName !== "" ? "../assets/pawns/" + model.pieceName + ".png" : ""
                    visible: model.pieceName !== ""
                    
                    // --- 3. Dynamic Position Layout ---
                    // While dragging, disable normal centering layout so it can move freely.
                    x: dragArea.drag.active ? undefined : (parent.width - width) / 2
                    y: dragArea.drag.active ? undefined : (parent.height - height) / 2
                    
                    // Only show the image if it actually has a file attached to it
                }

                MouseArea {
                    id: dragArea                    
                    anchors.fill: parent
                    drag.target: pieceImage                    
                    drag.axis: Drag.XAndYAxis                    
                    cursorShape: Qt.PointingHandCursor
                    
                    // 1. Instantly highlight the square the moment they click down!
                    onPressed: {
                        if (pieceImage.source.toString() !== "") {
                            boardGrid.selectedIndex = index;
                        }
                    }

                    // 2. If it was just a normal click, ensure it stays highlighted
                    onClicked: {
                        if (pieceImage.source.toString() !== "") {
                            boardGrid.selectedIndex = index;
                        }
                    }
                                        
                    onReleased: {
                        var gridPoint = mapToItem(boardGrid, mouseX, mouseY);
                        var targetCol = Math.floor(gridPoint.x / tile.width);
                        var targetRow = Math.floor(gridPoint.y / tile.height);
                        
                        if (targetCol >= 0 && targetCol < 8 && targetRow >= 0 && targetRow < 8) {
                            var targetIndex = (targetRow * 8) + targetCol;
                            var pieceTypeMoving = model.pieceName;
                            
                            boardModel.setProperty(index, "pieceName", ""); 
                            boardModel.setProperty(targetIndex, "pieceName", pieceTypeMoving); 
                        }
                        
                        pieceImage.x = (parent.width - pieceImage.width) / 2;
                        pieceImage.y = (parent.height - pieceImage.height) / 2;

                        // 3. Deselect the square when the drag/drop is finished!
                        // (If this was a normal click, the onClicked signal will fire immediately 
                        // after this and turn the selection back on!)
                        boardGrid.selectedIndex = -1;
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
