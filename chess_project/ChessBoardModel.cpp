#include "ChessBoardModel.h"
#include "Pieces.h"

ChessBoardModel::ChessBoardModel(QObject* parent) : QAbstractListModel(parent) {
    setupBoard();
}

void ChessBoardModel::setupBoard() {
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

int ChessBoardModel::rowCount(const QModelIndex&) const {
    return 64;
}

QVariant ChessBoardModel::data(const QModelIndex& index, int role) const {
    if (!index.isValid()) return QVariant();
    int r = index.row() / 8;
    int c = index.row() % 8;
    auto piece = board[r][c];

    if (role == TypeRole) return piece ? static_cast<int>(piece->getType()) : -1;
    if (role == ColorRole) return piece ? static_cast<int>(piece->getColor()) : -1;
    if (role == HighlightRole) {
        for (const auto& m : highlightedMoves) if (m.row == r && m.col == c) return true;
        return false;
    }
    return QVariant();
}

QHash<int, QByteArray> ChessBoardModel::roleNames() const {
    return { {TypeRole, "pieceType"}, {ColorRole, "pieceColor"}, {HighlightRole, "isHighlighted"} };
}

bool ChessBoardModel::isCheck(Color kingColor) const {
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

std::vector<Position> ChessBoardModel::getLegalMoves(std::shared_ptr<Piece> piece) {
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

void ChessBoardModel::selectSquare(int index) {
    int r = index / 8;
    int c = index % 8;

    if (selectedIndex == -1) {
        if (board[r][c] && board[r][c]->getColor() == currentTurn) {
            selectedIndex = index;
            highlightedMoves = getLegalMoves(board[r][c]);
            emit dataChanged(createIndex(0, 0), createIndex(63, 0), { HighlightRole });
        }
    }
    else {
        bool isValidMove = false;
        for (auto m : highlightedMoves) if (m.row == r && m.col == c) isValidMove = true;

        if (isValidMove) {
            movePiece(selectedIndex / 8, selectedIndex % 8, r, c);
            currentTurn = (currentTurn == Color::White) ? Color::Black : Color::White;
        }

        selectedIndex = -1;
        highlightedMoves.clear();
        emit dataChanged(createIndex(0, 0), createIndex(63, 0), { TypeRole, ColorRole, HighlightRole });
    }
}

void ChessBoardModel::movePiece(int fromRow, int fromCol, int toRow, int toCol) {
    auto piece = board[fromRow][fromCol];
    piece->setPosition({ toRow, toCol });
    piece->markAsMoved();
    board[toRow][toCol] = piece;
    board[fromRow][fromCol] = nullptr;
}