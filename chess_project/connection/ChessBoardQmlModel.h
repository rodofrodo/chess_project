#pragma once
#include <QAbstractListModel>
#include <QTimer>
#include <memory>
#include "../logic/ChessGame.h"

class ChessBoardQmlModel : public QAbstractListModel {
    Q_OBJECT
        Q_PROPERTY(QString gameStateText READ getGameStateText NOTIFY gameStateChanged)
        Q_PROPERTY(QVariantList moveHistoryList READ getMoveHistoryList NOTIFY moveHistoryChanged)
        Q_PROPERTY(bool isPromotionActive READ getIsPromotionActive NOTIFY promotionChanged)
        Q_PROPERTY(QString whiteTimeText READ getWhiteTimeText NOTIFY timeChanged)
        Q_PROPERTY(QString blackTimeText READ getBlackTimeText NOTIFY timeChanged)
        Q_PROPERTY(bool isWhiteTurn READ getIsWhiteTurn NOTIFY gameStateChanged)
        //
        Q_PROPERTY(int kingInCheckIndex READ getKingInCheckIndex NOTIFY gameStateChanged)
        Q_PROPERTY(QVariantList whiteCapturedList READ getWhiteCapturedList NOTIFY capturedPiecesChanged)
        Q_PROPERTY(QVariantList blackCapturedList READ getBlackCapturedList NOTIFY capturedPiecesChanged)

public:
    enum ChessRoles { TypeRole = Qt::UserRole + 1, ColorRole, HighlightRole };
    explicit ChessBoardQmlModel(QObject* parent = nullptr);

    int rowCount(const QModelIndex& parent = QModelIndex()) const override;
    QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE void selectSquare(int index);
    Q_INVOKABLE void promotePawn(int pieceType);
    Q_INVOKABLE void startGame(QString timeControl);

    QString getGameStateText() const;
    bool getIsPromotionActive() const;
    QString getWhiteTimeText() const;
    QString getBlackTimeText() const;
    bool getIsWhiteTurn() const;
    QVariantList getMoveHistoryList() const;
    QVariantList getWhiteCapturedList() const;
    QVariantList getBlackCapturedList() const;

    //
    int getKingInCheckIndex() const;

signals:
    void gameStateChanged();
    void moveHistoryChanged();
    void promotionChanged();
    void timeChanged();
    void capturedPiecesChanged();

private:
    std::unique_ptr<ChessGame> game;
    QTimer* timer;

    void onTick();
};
