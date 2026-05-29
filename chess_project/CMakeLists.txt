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

qt_standard_project_setup()

set(PROJECT_SOURCES
    main.cpp
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
            pages/StartPage.qml
            pages/MainMenu.qml
            elements/ChessStartText.qml
            elements/GetStartedBtn.qml
            assets/startpage_bg.png
            assets/mainmenu_bg.png
            assets/product-sans-bold.ttf
            assets/product-sans-italic-bold.ttf
            assets/product-sans-italic.ttf
            assets/product-sans-regular.ttf
            assets/icon.png
    )
endif()

set_target_properties(${PROJECT_NAME}
    PROPERTIES
        WIN32_EXECUTABLE TRUE
)

target_link_libraries(${PROJECT_NAME}
    PUBLIC
        Qt::Quick
)

if(Qt6_FOUND)
    qt_import_qml_plugins(${PROJECT_NAME})
endif()
