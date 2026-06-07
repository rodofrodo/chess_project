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
    if (role == HighlightRole) {
        return game->isHighlighted(r, c);
    }

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
    if (index < 0 || index >= 64) return;
    
    game->selectSquare(index / 8, index % 8);
    emit dataChanged(createIndex(0, 0), createIndex(63, 0), {TypeRole, ColorRole, HighlightRole});
}
