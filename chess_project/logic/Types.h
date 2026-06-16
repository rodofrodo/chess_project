#pragma once
#include <string>
// kolor gracza
enum class Color { White, Black };
// typ figury
enum class PieceType { Pawn = 0, Rook = 1, Knight = 2, Bishop = 3, Queen = 4, King = 5 };
// stan gry
enum class GameState { WaitingForStart, Active, Promotion, WhiteWins, BlackWins, Stalemate, TimeOutWhite, TimeOutBlack };
// współrzędne pola na planszy
struct Position {
    int row;
    int col;
    
    bool operator==(const Position& other) const { return row == other.row && col == other.col; }
    bool operator!=(const Position& other) const { return !(*this == other); }
};
// zapis pojedynczego ruchu do historii
struct MoveRecord {
    std::string whiteMove;
    std::string blackMove;
};