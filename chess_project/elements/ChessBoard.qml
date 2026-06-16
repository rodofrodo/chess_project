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
        
        width: 890 
        height: 890
        
        color: "transparent"
        border.color: "black"
        border.width: 1
    }

    Grid {
        id: boardGrid
        columns: 8
        rows: 8
        anchors.centerIn: parent
        width: 888
        height: 888

        Repeater {
            model: boardModel

            delegate: Rectangle {
                id: tile
                width: boardGrid.width / 8
                height: boardGrid.height / 8
                
                property int row: Math.floor(index / 8)
                property int col: index % 8
                property bool isLightSquare: (row + col) % 2 === 0
                color: {
                    if (model.isHighlighted) {
                        return isLightSquare ? "#0077EE" : "#004E9C" 
                    } else {
                        return isLightSquare ? "#FFFFCD" : "#EC94A3" 
                    }
                }

                z: clickArea.drag.active ? 1 : 0 
                Rectangle {
                    anchors.fill: parent
                    color: "#900000" 
                    visible: index === root.kingInCheckIndex 
                }
                Image {
                    id: pieceImage    
                    width: implicitWidth
                    height: implicitHeight
                    fillMode: Image.Pad
                    x: clickArea.drag.active ? undefined : Math.floor((parent.width - implicitWidth) / 2)
                    y: clickArea.drag.active ? undefined : Math.floor((parent.height - implicitHeight) / 2) 
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
                    
                    property bool dragOccurred: false
                    onPositionChanged: {
                        if (drag.active) dragOccurred = true;
                    }

                    onPressed: {
                        dragOccurred = false;
                        boardModel.selectSquare(index);
                    }

                    onReleased: {
                        if (dragOccurred) {
                            var gridPoint = mapToItem(boardGrid, mouseX, mouseY);
                            var targetCol = Math.floor(gridPoint.x / tile.width);
                            var targetRow = Math.floor(gridPoint.y / tile.height);
                            
                            if (targetCol >= 0 && targetCol < 8 && targetRow >= 0 && targetRow < 8) {
                                var targetIndex = (targetRow * 8) + targetCol;
                                if (targetIndex !== index) {
                                    boardModel.selectSquare(targetIndex);
                                }
                            }
                        }
                        dragOccurred = false; 
                    }
                }
            }
        }
    }
    Row {
        anchors.bottom: boardGrid.top
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
    Column {
        anchors.right: boardGrid.left
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
    Rectangle {
        id: promotionBlocker
        anchors.fill: boardGrid
        color: "#AA000000"
        z: 200
        visible: boardModel.isPromotionActive
        MouseArea { anchors.fill: parent }
        Rectangle {
            anchors.centerIn: parent
            width: 80
            height: 300
            color: "white"
            radius: 8
            border.color: "#333333"
            border.width: 1

            Column {
                anchors.centerIn: parent
                spacing: 10
                Repeater {
                    model: [
                        { typeId: 4, name: "queen" },
                        { typeId: 2, name: "knight" },
                        { typeId: 3, name: "bishop" },
                        { typeId: 1, name: "rook" }
                    ]

                    delegate: Rectangle {
                        width: 60
                        height: 60
                        color: hoverArea.containsMouse ? "#eeeeee" : "transparent"
                        radius: 5

                        Image {
                            anchors.centerIn: parent
                        
                            property real scaleMultiplier: modelData.name === "rook" ? 0.75 : 1.0
                            width: 50 * scaleMultiplier
                            height: 50 * scaleMultiplier

                            fillMode: Image.PreserveAspectFit
                            sourceSize.height: 100

                            property string pieceColor: boardModel.isWhiteTurn ? "white" : "black"
                            source: "../assets/pawns/" + modelData.name + "_" + pieceColor + ".svg"
                        }

                        MouseArea {
                            id: hoverArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            
                            onClicked: {
                                boardModel.promotePawn(modelData.typeId)
                            }
                        }
                    }
                }
            }
        }
    }
    Rectangle {
        id: gameOverOverlay
        anchors.fill: boardGrid
        color: "#AA000000"
        z: 300
        visible: opacity > 0
        opacity: 0.0
        MouseArea { anchors.fill: parent }

        property string outcome: boardModel.gameStateText
        property bool isWhiteWin: outcome.includes("White Wins") || outcome.includes("White won")
        property bool isBlackWin: outcome.includes("Black Wins") || outcome.includes("Black won")
        property bool isDraw: outcome.includes("Stalemate")

        Rectangle {
            id: gameOverBox
            anchors.centerIn: parent
            width: 320
            height: 180
            radius: 12
            color: {
                if (gameOverOverlay.isWhiteWin) return "#FFFFFF";
                if (gameOverOverlay.isBlackWin) return "#000000";
                if (gameOverOverlay.isDraw) return "#FFB300";
                return "transparent";
            }
            border.color: gameOverOverlay.isWhiteWin ? "#E0E0E0" : "#222222"
            border.width: 1
            scale: 0.5 

            Column {
                anchors.centerIn: parent
                spacing: 15
                Text {
                    text: {
                        if (gameOverOverlay.isWhiteWin) return "White Won";
                        if (gameOverOverlay.isBlackWin) return "Black Won";
                        return "Stalemate";
                    }
                    color: gameOverOverlay.isBlackWin ? "white" : "black"
                    font.family: productSansBold.name
                    font.pixelSize: 32
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Text {
                    text: {
                        if (gameOverOverlay.isWhiteWin) return "1 - 0";
                        if (gameOverOverlay.isBlackWin) return "0 - 1";
                        return "1/2 - 1/2";
                    }
                    color: gameOverOverlay.isBlackWin ? "white" : "black"
                    font.family: productSansBold.name
                    font.pixelSize: 28
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                
                Text {
                    text: gameOverOverlay.outcome
                    color: gameOverOverlay.isBlackWin ? "#AAAAAA" : "#666666"
                    font.family: productSansRegular.name
                    font.pixelSize: 14
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                // 4.
                /*
                Rectangle {
                    width: 160
                    height: 40
                    radius: 20
                    // Match the theme of the winner's box
                    color: gameOverOverlay.isBlackWin ? "#333333" : "#F0F0F0"
                    anchors.horizontalCenter: parent.horizontalCenter

                    Text {
                        text: "Play Again"
                        font.family: productSansBold.name // productSansBold.name
                        font.pixelSize: 16
                        font.bold: true
                        color: gameOverOverlay.isBlackWin ? "white" : "black"
                        anchors.centerIn: parent
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        
                        // Subtle hover effect
                        hoverEnabled: true
                        onEntered: parent.opacity = 0.8
                        onExited: parent.opacity = 1.0

                        onClicked: {
                            // Instantly resets the entire game! 
                            // (Change "10|0" to whatever time control they are currently playing)
                            boardModel.startGame("10|0");
                        }
                    }
                }*/
            }
        }
        ParallelAnimation {
            id: gameOverAnim
            NumberAnimation { target: gameOverOverlay; property: "opacity"; to: 1.0; duration: 400 }
            NumberAnimation { target: gameOverBox; property: "scale"; to: 1.0; duration: 500; easing.type: Easing.OutBack }
        }

        onOutcomeChanged: {
            if (outcome !== "") {
                gameOverAnim.restart();
            } else {
                opacity = 0.0;
                gameOverBox.scale = 0.5;
            }
        }
    }
}
