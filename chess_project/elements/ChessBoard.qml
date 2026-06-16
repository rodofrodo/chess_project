import QtQuick

// The outer white border with rounded corners
Rectangle {
    id: root
    width: 970
    height: 970
    color: "white" 
    radius: 25

    property int kingInCheckIndex: boardModel.kingInCheckIndex

    function getPieceName(type, color) {
        if (type === -1) return "";
        var types = ["pawn", "rook", "knight", "bishop", "queen", "king"];
        var colors = ["white", "black"];
        return types[type] + "_" + colors[color];
    }

    FontLoader {
        id: productSansBold
        source: "../assets/product-sans-bold.ttf"
    }

    FontLoader {
        id: productSansRegular
        source: "../assets/product-sans-regular.ttf"
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

                // ==========================================
                // --- ADD THIS RED CHECK OVERLAY HERE ---
                // ==========================================
                Rectangle {
                    anchors.fill: parent
                    color: "#900000" 
                    // Only visible if this exact square is the one in check!
                    visible: index === root.kingInCheckIndex 
                }

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

    // ==========================================
    // PAWN PROMOTION OVERLAY
    // ==========================================
    Rectangle {
        id: promotionBlocker
        anchors.fill: boardGrid
        color: "#AA000000" // 66% transparent black
        z: 200 // Sits on top of EVERYTHING
        visible: boardModel.isPromotionActive
        
        // Trap mouse clicks so they can't click the board behind the menu
        MouseArea { anchors.fill: parent }

        // The White Menu Box (Matching your screenshot!)
        Rectangle {
            anchors.centerIn: parent
            width: 80
            height: 300 // Tall enough to fit 4 vertical pieces
            color: "white"
            radius: 8
            
            // A subtle drop shadow so it pops off the dark background
            border.color: "#333333"
            border.width: 1

            Column {
                anchors.centerIn: parent
                spacing: 10

                // We use an array of objects to map the name to your C++ PieceType Enums
                Repeater {
                    model: [
                        { typeId: 4, name: "queen" },
                        { typeId: 2, name: "knight" },
                        { typeId: 1, name: "rook" },
                        { typeId: 3, name: "bishop" }
                    ]

                    delegate: Rectangle {
                        width: 60
                        height: 60
                        color: hoverArea.containsMouse ? "#eeeeee" : "transparent"
                        radius: 5

                        Image {
                            // 1. Remove the fill anchors and use centerIn so we can resize it
                            anchors.centerIn: parent
                        
                            // 2. THE CUSTOM SCALE LOGIC
                            // If it's a rook, shrink it to 75%. Otherwise, leave it at 100%.
                            property real scaleMultiplier: modelData.name === "rook" ? 0.75 : 1.0
                        
                            // 3. Apply the scale! 
                            // We use a base size of 50, which matches your old 'margin: 5' look perfectly.
                            width: 50 * scaleMultiplier
                            height: 50 * scaleMultiplier

                            fillMode: Image.PreserveAspectFit
                            sourceSize.height: 100

                            // Dynamically grab White or Black SVGs based on whose turn it is
                            property string pieceColor: boardModel.isWhiteTurn ? "white" : "black"
                            source: "../assets/pawns/" + modelData.name + "_" + pieceColor + ".svg"
                        }

                        MouseArea {
                            id: hoverArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            
                            onClicked: {
                                // Tell C++ which piece we picked!
                                boardModel.promotePawn(modelData.typeId)
                            }
                        }
                    }
                }
            }
        }
    }

    // ==========================================
    // GAME OVER OVERLAY
    // ==========================================
    Rectangle {
        id: gameOverOverlay
        anchors.fill: boardGrid // Covers the board perfectly
        color: "#AA000000" // 66% transparent black background to dim the board
        z: 300 // Sits on top of EVERYTHING (including promotion menu)
        
        // Only visible when the animation triggers it
        visible: opacity > 0
        opacity: 0.0
        
        // Trap mouse clicks so players can't move pieces after the game ends
        MouseArea { anchors.fill: parent }

        // --- THE BRAIN: Figure out the outcome based on C++ text ---
        property string outcome: boardModel.gameStateText
        property bool isWhiteWin: outcome.includes("White Wins") || outcome.includes("White won")
        property bool isBlackWin: outcome.includes("Black Wins") || outcome.includes("Black won")
        property bool isDraw: outcome.includes("Stalemate")

        // The Main Popup Box
        Rectangle {
            id: gameOverBox
            anchors.centerIn: parent
            width: 320
            height: 180
            radius: 12
            
            // Match your screenshots exactly!
            color: {
                if (gameOverOverlay.isWhiteWin) return "#FFFFFF";
                if (gameOverOverlay.isBlackWin) return "#000000";
                if (gameOverOverlay.isDraw) return "#FFB300"; // The Golden Orange
                return "transparent";
            }
            
            // Subtle border to help the black/white boxes pop against the dark background
            border.color: gameOverOverlay.isWhiteWin ? "#E0E0E0" : "#222222"
            border.width: 1
            
            // Starts shrunk down for the animation
            scale: 0.5 

            Column {
                anchors.centerIn: parent
                spacing: 15

                // 1. The Title (White Won, Black Won, Stalemate)
                Text {
                    text: {
                        if (gameOverOverlay.isWhiteWin) return "White Won";
                        if (gameOverOverlay.isBlackWin) return "Black Won";
                        return "Stalemate";
                    }
                    color: gameOverOverlay.isBlackWin ? "white" : "black"
                    font.family: productSansBold.name // Replace with productSansBold.name if available
                    font.pixelSize: 32
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                // 2. The Score (1-0, 0-1, 1/2-1/2)
                Text {
                    text: {
                        if (gameOverOverlay.isWhiteWin) return "1 - 0";
                        if (gameOverOverlay.isBlackWin) return "0 - 1";
                        return "1/2 - 1/2";
                    }
                    color: gameOverOverlay.isBlackWin ? "white" : "black"
                    font.family: productSansBold.name // productSansBold.name
                    font.pixelSize: 28
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                
                // 3. Optional: The specific reason from C++ (e.g. "Checkmate" or "on time")
                Text {
                    text: gameOverOverlay.outcome
                    color: gameOverOverlay.isBlackWin ? "#AAAAAA" : "#666666"
                    font.family: productSansRegular.name
                    font.pixelSize: 14
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }

        // ==========================================
        // THE ANIMATION
        // ==========================================
        ParallelAnimation {
            id: gameOverAnim
            // Fade in the dark background
            NumberAnimation { target: gameOverOverlay; property: "opacity"; to: 1.0; duration: 400 }
            // "Punch" the box outwards to full size with a rubber-band bounce
            NumberAnimation { target: gameOverBox; property: "scale"; to: 1.0; duration: 500; easing.type: Easing.OutBack }
        }

        // Trigger the animation automatically when C++ says the game is over
        onOutcomeChanged: {
            if (outcome !== "") {
                gameOverAnim.restart();
            } else {
                // If the user clicks "New Game" and C++ resets the string, hide the box instantly
                opacity = 0.0;
                gameOverBox.scale = 0.5;
            }
        }
    }
}
