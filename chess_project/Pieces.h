#pragma once
#include "Piece.h"

void addSlidingMoves(std::vector<Position>& moves, const Position& pos, Color color,
    const std::vector<std::vector<std::shared_ptr<Piece>>>& board,
    const std::vector<std::pair<int, int>>& directions);

void addStepMoves(std::vector<Position>& moves, const Position& pos, Color color,
    const std::vector<std::vector<std::shared_ptr<Piece>>>& board,
    const std::vector<std::pair<int, int>>& steps);

class Pawn : public Piece {
public:
    Pawn(Color c, Position p) : Piece(c, p) {}
    PieceType getType() const override { return PieceType::Pawn; }
    std::vector<Position> getValidMoves(const std::vector<std::vector<std::shared_ptr<Piece>>>& board) const override;
};

class Rook : public Piece {
public:
    Rook(Color c, Position p) : Piece(c, p) {}
    PieceType getType() const override { return PieceType::Rook; }
    std::vector<Position> getValidMoves(const std::vector<std::vector<std::shared_ptr<Piece>>>& board) const override;
};

class Knight : public Piece {
public:
    Knight(Color c, Position p) : Piece(c, p) {}
    PieceType getType() const override { return PieceType::Knight; }
    std::vector<Position> getValidMoves(const std::vector<std::vector<std::shared_ptr<Piece>>>& board) const override;
};

class Bishop : public Piece {
public:
    Bishop(Color c, Position p) : Piece(c, p) {}
    PieceType getType() const override { return PieceType::Bishop; }
    std::vector<Position> getValidMoves(const std::vector<std::vector<std::shared_ptr<Piece>>>& board) const override;
};

class Queen : public Piece {
public:
    Queen(Color c, Position p) : Piece(c, p) {}
    PieceType getType() const override { return PieceType::Queen; }
    std::vector<Position> getValidMoves(const std::vector<std::vector<std::shared_ptr<Piece>>>& board) const override;
};

class King : public Piece {
public:
    King(Color c, Position p) : Piece(c, p) {}
    PieceType getType() const override { return PieceType::King; }
    std::vector<Position> getValidMoves(const std::vector<std::vector<std::shared_ptr<Piece>>>& board) const override;
};