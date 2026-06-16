#pragma once
#include <vector>
#include <memory>
#include "Types.h"

// klasa bazowa dla wszystkich figur
class Piece {
protected:
    Color color;
    Position position;
    bool hasMoved;

public:
    Piece(Color c, Position p) : color(c), position(p), hasMoved(false) {}
    virtual ~Piece() = default;

    Color getColor() const { return color; }
    Position getPosition() const { return position; }
    bool getHasMoved() const { return hasMoved; }

    void setPosition(Position p) { position = p; }
    void markAsMoved() { hasMoved = true; }

    virtual PieceType getType() const = 0;
    
    virtual std::vector<Position> getValidMoves(
        const std::vector<std::vector<std::shared_ptr<Piece>>>& board
    ) const = 0;
};