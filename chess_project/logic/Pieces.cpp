#include "Pieces.h"

// ruchy w linii prostej do napotkania przeszkody
void addSlidingMoves(std::vector<Position>& moves, const Position& pos, Color color,
    const std::vector<std::vector<std::shared_ptr<Piece>>>& board,
    const std::vector<std::pair<int, int>>& directions) {
    for (auto dir : directions) {
        int r = pos.row + dir.first;
        int c = pos.col + dir.second;

        while (r >= 0 && r < 8 && c >= 0 && c < 8) {
            // jeśli puste, dodaje jako możliwy ruch
            if (!board[r][c]) {
                moves.push_back({ r, c });
            }
            else {
                // zbija wroga i kończy ruch
                if (board[r][c]->getColor() != color) moves.push_back({ r, c });
                break;
            }
            // kolejny krok w tym samym kierunku
            r += dir.first;
            c += dir.second;
        }
    }
}

// pojedyncze skoki o wskazany wektor
void addStepMoves(std::vector<Position>& moves, const Position& pos, Color color,
    const std::vector<std::vector<std::shared_ptr<Piece>>>& board,
    const std::vector<std::pair<int, int>>& steps) {
    for (auto step : steps) {
        int r = pos.row + step.first;
        int c = pos.col + step.second;
        // jeśli mieści się na planszy
        if (r >= 0 && r < 8 && c >= 0 && c < 8) {
            // wejdzie jeśli puste lub stoi przeciwnik
            if (!board[r][c] || board[r][c]->getColor() != color) {
                moves.push_back({ r, c });
            }
        }
    }
}

std::vector<Position> Pawn::getValidMoves(const std::vector<std::vector<std::shared_ptr<Piece>>>& board) const {
    std::vector<Position> moves;
    // wyznacza kierunek zależnie od koloru
    int dir = (color == Color::White) ? -1 : 1;
    int r = position.row + dir;
    int c = position.col;

    // pojedynczy krok do przodu
    if (r >= 0 && r < 8 && !board[r][c]) {
        moves.push_back({ r, c });
        // podwójny skok na początku
        if (!getHasMoved()) {
            int r2 = r + dir;
            if (r2 >= 0 && r2 < 8 && !board[r2][c]) {
                moves.push_back({ r2, c });
            }
        }
    }
    // sprawdzanie uderzeń na ukos
    for (int dc : {-1, 1}) {
        if (r >= 0 && r < 8 && c + dc >= 0 && c + dc < 8) {
            if (board[r][c + dc] && board[r][c + dc]->getColor() != color) {
                moves.push_back({ r, c + dc });
            }
        }
    }
    return moves;
}

std::vector<Position> Rook::getValidMoves(const std::vector<std::vector<std::shared_ptr<Piece>>>& board) const {
    std::vector<Position> moves;
    // ruchy wieży w pionie i poziomie
    addSlidingMoves(moves, position, color, board, { {-1,0}, {1,0}, {0,-1}, {0,1} });
    return moves;
}

std::vector<Position> Bishop::getValidMoves(const std::vector<std::vector<std::shared_ptr<Piece>>>& board) const {
    std::vector<Position> moves;
    // ruchy gońca po skosie
    addSlidingMoves(moves, position, color, board, { {-1,-1}, {-1,1}, {1,-1}, {1,1} });
    return moves;
}

std::vector<Position> Queen::getValidMoves(const std::vector<std::vector<std::shared_ptr<Piece>>>& board) const {
    std::vector<Position> moves;
    // ruchy hetmana we wszystkie strony
    addSlidingMoves(moves, position, color, board, { {-1,0}, {1,0}, {0,-1}, {0,1}, {-1,-1}, {-1,1}, {1,-1}, {1,1} });
    return moves;
}

std::vector<Position> Knight::getValidMoves(const std::vector<std::vector<std::shared_ptr<Piece>>>& board) const {
    std::vector<Position> moves;
    // ruchy skoczka w kształcie litery L
    addStepMoves(moves, position, color, board, { {-2,-1}, {-2,1}, {-1,-2}, {-1,2}, {1,-2}, {1,2}, {2,-1}, {2,1} });
    return moves;
}

std::vector<Position> King::getValidMoves(const std::vector<std::vector<std::shared_ptr<Piece>>>& board) const {
    std::vector<Position> moves;
    // kroki króla o jedno pole
    addStepMoves(moves, position, color, board, { {-1,0}, {1,0}, {0,-1}, {0,1}, {-1,-1}, {-1,1}, {1,-1}, {1,1} });
    return moves;
}