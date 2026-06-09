#include "ChessBoardQmlModel.h"

ChessBoardQmlModel::ChessBoardQmlModel(QObject* parent)
    : QAbstractListModel(parent), game(std::make_unique<ChessGame>()) {
}

int ChessBoardQmlModel::rowCount(const QModelIndex& parent) const {
    if (parent.isValid()) return 0;
    return 64;
}

QVariant ChessBoardQmlModel::data(const QModelIndex& index, int role) const {
    if (!index.isValid()) return QVariant();

    int r = index.row() / 8;
    int c = index.row() % 8;

    if (role == TypeRole) {
        auto piece = game->getPieceAt(r, c);
        return piece ? static_cast<int>(piece->getType()) : -1;
    }
    if (role == ColorRole) {
        auto piece = game->getPieceAt(r, c);
        return piece ? static_cast<int>(piece->getColor()) : -1;
    }
    if (role == HighlightRole) return game->isHighlighted(r, c);

    return QVariant();
}

QHash<int, QByteArray> ChessBoardQmlModel::roleNames() const {
    return {
        {TypeRole, "pieceType"},
        {ColorRole, "pieceColor"},
        {HighlightRole, "isHighlighted"}
    };
}

void ChessBoardQmlModel::selectSquare(int index) {
    int r = index / 8;
    int c = index % 8;
    game->selectSquare(r, c);

    emit dataChanged(createIndex(0, 0), createIndex(63, 0), { TypeRole, ColorRole, HighlightRole });
    emit promotionChanged();
    emit gameStateChanged();
}

void ChessBoardQmlModel::promotePawn(int pieceType) {
    game->promotePawn(static_cast<PieceType>(pieceType));

    emit dataChanged(createIndex(0, 0), createIndex(63, 0), { TypeRole, ColorRole, HighlightRole });
    emit promotionChanged();
    emit gameStateChanged();
}

QString ChessBoardQmlModel::getGameStateText() const {
    switch (game->getGameState()) {
    case GameState::WhiteWins: return "Checkmate! White Wins";
    case GameState::BlackWins: return "Checkmate! Black Wins";
    case GameState::Stalemate: return "Stalemate";
    default: return "";
    }
}

bool ChessBoardQmlModel::getIsPromotionActive() const {
    return game->getGameState() == GameState::Promotion;
}