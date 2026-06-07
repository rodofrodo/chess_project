#pragma once
#include <vector>
#include <memory>
#include "Piece.h"

class ChessGame {
public:
    ChessGame();
    std::shared_ptr<Piece> getPieceAt(int row, int col) const;
    bool isHighlighted(int row, int col) const;
    void selectSquare(int row, int col);
private:
    std::vector<std::vector<std::shared_ptr<Piece>>> board;
    int selectedRow = -1;
    int selectedCol = -1;
    std::vector<Position> highlightedMoves;
    Color currentTurn = Color::White;

    void setupBoard();
    bool isCheck(Color kingColor) const;
    std::vector<Position> getLegalMoves(std::shared_ptr<Piece> piece);
    void movePiece(int fromRow, int fromCol, int toRow, int toCol);
};
