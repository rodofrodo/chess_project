#include "ChessGame.h"
#include "Pieces.h"

ChessGame::ChessGame() {
    setupBoard();
}

std::shared_ptr<Piece> ChessGame::getPieceAt(int row, int col) const {
    if (row >= 0 && row < 8 && col >= 0 && col < 8) {
        return board[row][col];
    }
    return nullptr;
}

bool ChessGame::isHighlighted(int row, int col) const {
    for (const auto& m : highlightedMoves) {
        if (m.row == row && m.col == col) return true;
    }
    return false;
}

void ChessGame::setupBoard() {
    board.assign(8, std::vector<std::shared_ptr<Piece>>(8, nullptr));

    auto setupRow = [&](int row, Color color) {
        board[row][0] = std::make_shared<Rook>(color, Position{ row, 0 });
        board[row][1] = std::make_shared<Knight>(color, Position{ row, 1 });
        board[row][2] = std::make_shared<Bishop>(color, Position{ row, 2 });
        board[row][3] = std::make_shared<Queen>(color, Position{ row, 3 });
        board[row][4] = std::make_shared<King>(color, Position{ row, 4 });
        board[row][5] = std::make_shared<Bishop>(color, Position{ row, 5 });
        board[row][6] = std::make_shared<Knight>(color, Position{ row, 6 });
        board[row][7] = std::make_shared<Rook>(color, Position{ row, 7 });
        };

    setupRow(0, Color::Black);
    setupRow(7, Color::White);

    for (int i = 0; i < 8; ++i) {
        board[1][i] = std::make_shared<Pawn>(Color::Black, Position{ 1, i });
        board[6][i] = std::make_shared<Pawn>(Color::White, Position{ 6, i });
    }
}

bool ChessGame::isCheck(Color kingColor) const {
    Position kingPos{ -1, -1 };
    for (int r = 0; r < 8; ++r) {
        for (int c = 0; c < 8; ++c) {
            if (board[r][c] && board[r][c]->getType() == PieceType::King && board[r][c]->getColor() == kingColor) {
                kingPos = { r, c };
                break;
            }
        }
    }

    for (int r = 0; r < 8; ++r) {
        for (int c = 0; c < 8; ++c) {
            if (board[r][c] && board[r][c]->getColor() != kingColor) {
                auto moves = board[r][c]->getValidMoves(board);
                for (auto m : moves) {
                    if (m == kingPos) return true;
                }
            }
        }
    }
    return false;
}

std::vector<Position> ChessGame::getLegalMoves(std::shared_ptr<Piece> piece) {
    auto rawMoves = piece->getValidMoves(board);
    std::vector<Position> legalMoves;

    for (auto move : rawMoves) {
        int fromR = piece->getPosition().row;
        int fromC = piece->getPosition().col;
        auto destPiece = board[move.row][move.col];

        board[move.row][move.col] = piece;
        board[fromR][fromC] = nullptr;
        piece->setPosition(move);

        if (!isCheck(piece->getColor())) {
            legalMoves.push_back(move);
        }

        piece->setPosition({ fromR, fromC });
        board[fromR][fromC] = piece;
        board[move.row][move.col] = destPiece;
    }
    return legalMoves;
}

void ChessGame::selectSquare(int row, int col) {
    if (selectedRow == -1 && selectedCol == -1) {
        if (board[row][col] && board[row][col]->getColor() == currentTurn) {
            selectedRow = row;
            selectedCol = col;
            highlightedMoves = getLegalMoves(board[row][col]);
        }
    }
    else {
        bool isValidMove = false;
        for (auto m : highlightedMoves) {
            if (m.row == row && m.col == col) {
                isValidMove = true;
                break;
            }
        }

        if (isValidMove) {
            movePiece(selectedRow, selectedCol, row, col);
            currentTurn = (currentTurn == Color::White) ? Color::Black : Color::White;
        }

        selectedRow = -1;
        selectedCol = -1;
        highlightedMoves.clear();
    }
}

void ChessGame::movePiece(int fromRow, int fromCol, int toRow, int toCol) {
    auto piece = board[fromRow][fromCol];
    piece->setPosition({ toRow, toCol });
    piece->markAsMoved();
    board[toRow][toCol] = piece;
    board[fromRow][fromCol] = nullptr;
}
