#include "Pawn.h"

std::vector<Position> Pawn::getValidMoves(
    const std::vector<std::vector<std::shared_ptr<Piece>>>& board
) const {
    std::vector<Position> validMoves;
    const int direction = (color == Color::White) ? -1 : 1;
    const int forwardRow = position.row + direction;

    auto isInside = [](int r, int c) { return r >= 0 && r < 8 && c >= 0 && c < 8; };

    if (isInside(forwardRow, position.col) && !board[forwardRow][position.col]) {
        validMoves.push_back({ forwardRow, position.col });
        if (!hasMoved && isInside(position.row + 2 * direction, position.col) &&
            !board[position.row + 2 * direction][position.col]) {
            validMoves.push_back({ position.row + 2 * direction, position.col });
        }
    }

    const int captureCols[] = { position.col - 1, position.col + 1 };
    for (int col : captureCols) {
        if (isInside(forwardRow, col)) {
            const auto& target = board[forwardRow][col];
            if (target && target->getColor() != this->color) {
                validMoves.push_back({ forwardRow, col });
            }
        }
    }
    return validMoves;
}