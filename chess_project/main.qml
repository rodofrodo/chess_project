import QtQuick 2.9
import QtQuick.Window 2.2

Window {
    visible: true
    width: 600
    height: 600
    title: "Chess Project"
    color: "#333333"

    GridView {
        id: boardView
        width: 8 * 70
        height: 8 * 70
        cellWidth: 70
        cellHeight: 70
        anchors.centerIn: parent
        interactive: false
        
        model: chessModel

        delegate: Rectangle {
            width: boardView.cellWidth
            height: boardView.cellHeight
            
            property int row: index / 8
            property int col: index % 8
            
            color: (row + col) % 2 === 0 ? "#F0D9B5" : "#B58863"

            Rectangle {
                anchors.fill: parent
                color: "#7BCC70"
                opacity: 0.6
                visible: isHighlighted
            }

            Text {
                anchors.centerIn: parent
                font.pointSize: 32
                color: pieceColor === 0 ? "white" : "black"
                text: getPieceSymbol(pieceType)
                style: Text.Outline
                styleColor: "black"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: chessModel.selectSquare(index)
            }
        }
    }

    function getPieceSymbol(type) {
        switch(type) {
            case 0: return "♙"
            case 1: return "♖"
            case 2: return "♘"
            case 3: return "♗"
            case 4: return "♕"
            case 5: return "♔"
            default: return ""
        }
    }
}
