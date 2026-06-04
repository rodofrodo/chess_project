#pragma once
#include <vector>
#include <memory>
#include "Types.h"

class Piece {
protected:
    Color color;
    Position position;
    bool hasMoved;

public:
    Piece(Color c, Position p) : color(c), position(p), hasMoved(false) {}
    virtual ~Piece() = default;

    [[nodiscard]] Color getColor() const { return color; }
    [[nodiscard]] Position getPosition() const { return position; }
    [[nodiscard]] bool getHasMoved() const { return hasMoved; }

    void setPosition(Position p) { position = p; }
    void markAsMoved() { hasMoved = true; }

    [[nodiscard]] virtual PieceType getType() const = 0;
    [[nodiscard]] virtual std::vector<Position> getValidMoves(
        const std::vector<std::vector<std::shared_ptr<Piece>>>& board
    ) const = 0;
};