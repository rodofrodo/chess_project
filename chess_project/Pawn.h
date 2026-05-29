#pragma once
#include "Piece.h"

class Pawn : public Piece {
public:
    Pawn(Color c, Position p) : Piece(c, p) {}

    [[nodiscard]] PieceType getType() const override { return PieceType::Pawn; }

    [[nodiscard]] std::vector<Position> getValidMoves(
        const std::vector<std::vector<std::shared_ptr<Piece>>>& board
    ) const override;
}