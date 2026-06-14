cmake_minimum_required(VERSION 3.16)
project(chess_project LANGUAGES CXX)

include(qt.cmake)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(QT NAMES Qt6 Qt5 REQUIRED COMPONENTS Core)
find_package(Qt${QT_VERSION_MAJOR}
    COMPONENTS
        Quick
)
find_package(Qt6 REQUIRED COMPONENTS Core Gui Qml Quick QuickControls2)

qt_standard_project_setup()

set(PROJECT_SOURCES
    main.cpp
    logic/Piece.h
    logic/Types.h
    logic/Pieces.cpp
    logic/Pieces.h
    logic/ChessBoardModel.cpp
    logic/ChessBoardModel.h
)

if(QT_VERSION VERSION_LESS 5.15)
    qt5_add_resources(PROJECT_SOURCES qml.qrc)
elseif(QT_VERSION VERSION_LESS 6.2)
    qt_add_resources(PROJECT_SOURCES qml.qrc)
endif()

qt_add_executable(chess_project ${PROJECT_SOURCES}
    app_icon.rc
)

if(QT_VERSION VERSION_GREATER_EQUAL 6.2)
    qt_add_qml_module(${PROJECT_NAME}
        URI chess_project
        VERSION 1.0
        RESOURCE_PREFIX "/qt/qml/"
        QML_FILES
            main.qml
            # pages
            pages/CreditsPage.qml
            pages/GamePage.qml
            pages/MainMenu.qml
            pages/StartPage.qml
            # elements
            elements/CapturedPieces.qml
            elements/ChessBoard.qml
            elements/ChessStartText.qml
            elements/GetStartedBtn.qml
            elements/MenuButton.qml
            elements/GoBackBtn.qml
            elements/MoveHistoryPanel.qml
            elements/PlayerTimer.qml
            elements/TimeControlMenu.qml
            # assets
            assets/startpage_bg.png
            assets/mainmenu_bg.png
            assets/creditspage_bg.png
            assets/product-sans-bold.ttf
            assets/product-sans-italic-bold.ttf
            assets/product-sans-italic.ttf
            assets/product-sans-regular.ttf
            assets/icon.png
            # -- pawns --
            # black
            assets/pawns/bishop_black.png
            assets/pawns/king_black.png
            assets/pawns/knight_black.png
            assets/pawns/pawn_black.png
            assets/pawns/queen_black.png
            assets/pawns/rook_black.png
            # white
            assets/pawns/bishop_white.png
            assets/pawns/king_white.png
            assets/pawns/knight_white.png
            assets/pawns/pawn_white.png
            assets/pawns/queen_white.png
            assets/pawns/rook_white.png
    )
endif()

set_target_properties(${PROJECT_NAME}
    PROPERTIES
        WIN32_EXECUTABLE FALSE # For GUI applications on Windows, set this to TRUE. For console applications, set it to FALSE.
)

target_link_libraries(${PROJECT_NAME}
    PUBLIC
        Qt::Quick
        Qt6::QuickControls2
)

if(Qt6_FOUND)
    qt_import_qml_plugins(${PROJECT_NAME})
endif()
