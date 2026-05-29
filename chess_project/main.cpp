#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include "Pawn.h"
#include <iostream>

int main(int argc, char *argv[])
{
    Position testPos{ 6, 0 };
    Pawn testPawn(Color::White, testPos);

    std::cout << "--- Pawn Test ---" << std::endl;
    std::cout << "Piece type: " << static_cast<int>(testPawn.getType()) << std::endl;
    std::cout << "Position: " << testPawn.getPosition().row << "," << testPawn.getPosition().col << std::endl;
    std::cout << "-----------------" << std::endl;
#if defined(Q_OS_WIN) && QT_VERSION_CHECK(5, 6, 0) <= QT_VERSION && QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/qt/qml/chess_project/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
