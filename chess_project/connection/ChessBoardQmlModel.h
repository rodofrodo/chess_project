#pragma once
#include <QAbstractListModel>
#include <memory>
#include "../logic/ChessGame.h"

class ChessBoardQmlModel : public QAbstractListModel {
    Q_OBJECT
public:
    enum ChessRoles { TypeRole = Qt::UserRole + 1, ColorRole, HighlightRole };
    explicit ChessBoardQmlModel(QObject* parent = nullptr);

    int rowCount(const QModelIndex& parent = QModelIndex()) const override;
    QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE void selectSquare(int index);

private:
    std::unique_ptr<ChessGame> game;
};
