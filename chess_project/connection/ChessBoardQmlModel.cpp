#include "ChessBoardQmlModel.h"
#include <QVariantList>
#include <QVariantMap>

ChessBoardQmlModel::ChessBoardQmlModel(QObject* parent)
    : QAbstractListModel(parent), game(std::make_unique<ChessGame>()), timer(new QTimer(this)) {
    connect(timer, &QTimer::timeout, this, &ChessBoardQmlModel::onTick);
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
    emit moveHistoryChanged();
    emit capturedPiecesChanged();
}

void ChessBoardQmlModel::promotePawn(int pieceType) {
    game->promotePawn(static_cast<PieceType>(pieceType));

    emit dataChanged(createIndex(0, 0), createIndex(63, 0), { TypeRole, ColorRole, HighlightRole });
    emit promotionChanged();
    emit gameStateChanged();
    emit moveHistoryChanged();
    emit capturedPiecesChanged();
}

QString ChessBoardQmlModel::getGameStateText() const {
    switch (game->getGameState()) {
    case GameState::WhiteWins: return "Checkmate! White Wins";
    case GameState::BlackWins: return "Checkmate! Black Wins";
    case GameState::Stalemate: return "Stalemate";
    case GameState::TimeOutWhite: return "Black won on time";
    case GameState::TimeOutBlack: return "White won on time";
    default: return "";
    }
}

bool ChessBoardQmlModel::getIsPromotionActive() const {
    return game->getGameState() == GameState::Promotion;
}

void ChessBoardQmlModel::onTick() {
    game->updateClock();
    emit timeChanged();
    emit gameStateChanged();
}

void ChessBoardQmlModel::startGame(QString timeControl) {
    QStringList parts = timeControl.split("|");
    int minutes = 0;
    int incrementSeconds = 0;
    if (parts.size() >= 2) {
        minutes = parts[0].trimmed().toInt();
        incrementSeconds = parts[1].trimmed().toInt();
    }
    game->startGame(minutes, incrementSeconds);
    if (!timer->isActive()) {
        timer->start(50);
    }
    emit moveHistoryChanged();
    emit capturedPiecesChanged();
}

QString ChessBoardQmlModel::getWhiteTimeText() const {
    if (game->getGameState() == GameState::TimeOutWhite) {
        return "0:00";
    }
    long long ms = game->getClock().getWhiteTimeMs();
    int s = ms / 1000;
    int m = s / 60;
    s %= 60;
    return QString::asprintf("%d:%02d", m, s);
}

QString ChessBoardQmlModel::getBlackTimeText() const {
    if (game->getGameState() == GameState::TimeOutBlack) {
        return "0:00";
    }
    long long ms = game->getClock().getBlackTimeMs();
    int s = ms / 1000;
    int m = s / 60;
    s %= 60;
    return QString::asprintf("%d:%02d", m, s);
}

bool ChessBoardQmlModel::getIsWhiteTurn() const {
    return game->getCurrentTurn() == Color::White;
}

//
int ChessBoardQmlModel::getKingInCheckIndex() const {
    return game->getKingInCheckIndex();
}
QVariantList ChessBoardQmlModel::getMoveHistoryList() const {
    QVariantList list;
    for (const auto& record : game->getMoveHistory()) {
        QVariantMap map;
        map["whiteMove"] = QString::fromStdString(record.whiteMove);
        map["blackMove"] = QString::fromStdString(record.blackMove);
        list.append(map);
    }
    return list;
}

QVariantList ChessBoardQmlModel::getWhiteCapturedList() const {
    QVariantList list;
    for (PieceType type : game->getWhiteCapturedPieces()) {
        QString name;
        switch (type) {
            case PieceType::Pawn: name = "pawn"; break;
            case PieceType::Knight: name = "knight"; break;
            case PieceType::Bishop: name = "bishop"; break;
            case PieceType::Rook: name = "rook"; break;
            case PieceType::Queen: name = "queen"; break;
            default: break;
        }
        if (!name.isEmpty()) list.append(name);
    }
    return list;
}

QVariantList ChessBoardQmlModel::getBlackCapturedList() const {
    QVariantList list;
    for (PieceType type : game->getBlackCapturedPieces()) {
        QString name;
        switch (type) {
            case PieceType::Pawn: name = "pawn"; break;
            case PieceType::Knight: name = "knight"; break;
            case PieceType::Bishop: name = "bishop"; break;
            case PieceType::Rook: name = "rook"; break;
            case PieceType::Queen: name = "queen"; break;
            default: break;
        }
        if (!name.isEmpty()) list.append(name);
    }
    return list;
}
