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
    GameState getGameState() const;
    void promotePawn(PieceType type);

private:
    std::vector<std::vector<std::shared_ptr<Piece>>> board;
    int selectedRow = -1;
    int selectedCol = -1;
    std::vector<Position> highlightedMoves;
    Color currentTurn = Color::White;
    GameState gameState = GameState::Active;
    Position enPassantTarget = { -1, -1 };
    Position pendingPromotion = { -1, -1 };

    void setupBoard();
    bool isCheck(Color kingColor) const;
    bool isSquareAttacked(Position pos, Color attackerColor) const;
    void updateGameState();
    std::vector<Position> getLegalMoves(std::shared_ptr<Piece> piece);
    void movePiece(int fromRow, int fromCol, int toRow, int toCol);
};