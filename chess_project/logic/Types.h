#pragma once

enum class Color { White, Black };
enum class PieceType { Pawn = 0, Rook = 1, Knight = 2, Bishop = 3, Queen = 4, King = 5 };
enum class GameState { WaitingForStart, Active, Promotion, WhiteWins, BlackWins, Stalemate, TimeOutWhite, TimeOutBlack };

struct Position {
    int row;
    int col;
    bool operator==(const Position& other) const { return row == other.row && col == other.col; }
    bool operator!=(const Position& other) const { return !(*this == other); }
};

#include <string>

struct MoveRecord {
    std::string whiteMove;
    std::string blackMove;
};