#pragma once
#include <vector>
#include <memory>
#include "Piece.h"
#include "ChessClock.h"

class ChessGame {
public:
    ChessGame();
    std::shared_ptr<Piece> getPieceAt(int row, int col) const;
    bool isHighlighted(int row, int col) const;
    void selectSquare(int row, int col);
    GameState getGameState() const;
    Color getCurrentTurn() const { return currentTurn; }
    void promotePawn(PieceType type);
    void startGame(int totalMinutes, int incrementSeconds);
    const std::vector<MoveRecord>& getMoveHistory() const;
    const std::vector<PieceType>& getWhiteCapturedPieces() const;
    const std::vector<PieceType>& getBlackCapturedPieces() const;
    void updateClock();
    const ChessClock& getClock() const;

private:
    std::vector<std::vector<std::shared_ptr<Piece>>> board;
    int selectedRow = -1;
    int selectedCol = -1;
    std::vector<Position> highlightedMoves;
    Color currentTurn = Color::White;
    GameState gameState = GameState::WaitingForStart;
    Position enPassantTarget = { -1, -1 };
    Position pendingPromotion = { -1, -1 };
    ChessClock clock;
    std::vector<MoveRecord> moveHistory;
    std::vector<PieceType> whiteCapturedPieces;
    std::vector<PieceType> blackCapturedPieces;

    void setupBoard();
    std::string toAlgebraic(std::shared_ptr<Piece> piece, Position from, Position to, bool isCapture, bool isCastling);
    bool isCheck(Color kingColor) const;
    bool isSquareAttacked(Position pos, Color attackerColor) const;
    void updateGameState();
    std::vector<Position> getLegalMoves(std::shared_ptr<Piece> piece);
    void movePiece(int fromRow, int fromCol, int toRow, int toCol);
};