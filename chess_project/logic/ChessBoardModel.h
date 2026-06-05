#pragma once
#include <QAbstractListModel>
#include <vector>
#include <memory>
#include "Piece.h"

class ChessBoardModel : public QAbstractListModel {
    Q_OBJECT
public:
    enum ChessRoles { TypeRole = Qt::UserRole + 1, ColorRole, HighlightRole };

    explicit ChessBoardModel(QObject* parent = nullptr);

    int rowCount(const QModelIndex& parent = QModelIndex()) const override;
    QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE void selectSquare(int index);

private:
    std::vector<std::vector<std::shared_ptr<Piece>>> board;
    int selectedIndex = -1;
    std::vector<Position> highlightedMoves;
    Color currentTurn = Color::White;

    void setupBoard();
    bool isCheck(Color kingColor) const;
    std::vector<Position> getLegalMoves(std::shared_ptr<Piece> piece);
    void movePiece(int fromRow, int fromCol, int toRow, int toCol);
};