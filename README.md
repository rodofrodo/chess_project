# ♟️ Qt Quick Chess

A modern, highly polished local multiplayer Chess application featuring a robust **C++ engine backend** and a sleek, animated **QML frontend**.

## 👥 Authors

| Name | Role | GitHub |
| :--- | :--- | :--- |
| **Bartosz Strączek** | Lead Developer (UI/UX & Frontend Architecture) | [@rodofrodo](https://github.com/rodofrodo) |
| **Łukasz Międlar** | Backend Developer (C++ Core Engine & Game Logic) | [@Lucasso00](https://github.com/Lucasso00) |
| **Marek Masorz** | Integration Engineer (C++ to QML Bridge) | [@M3rrQu](https://github.com/M3rrQu) |

## ✨ Features
- **Complete Chess Logic**: Full support for standard rules, including check, checkmate, stalemate, castling, en passant, and pawn promotion.
- **Modern UI/UX**: A responsive, beautifully designed interface utilizing `QtQuick` and `QtQuick.Controls`.
- **Smooth Animations**: Spring-loaded popups (`Easing.OutBack`) for Check warnings, Game Over states, and Pawn Promotion.
- **Dynamic Time Controls**: Fully functional chess clocks supporting Custom, Rapid, Blitz, and Bullet time controls with increments.
- **Live Match Tracking**:
  - Auto-scrolling move history panel.
  - Visual capture boards dynamically scaling based on piece type.
  - Turn indicators.
- **Seamless Navigation**: Uses QML `StackView` architecture for memory-efficient navigation between the Main Menu and the Game Board.

## 📸 Screenshots
_there will be screenshots_

## 🏗️ Architecture
This project strictly adheres to the Model-View architecture, cleanly separating the game logic from the user interface:
- **Backend (`C++`)**: The `ChessGame` class handles all rule validation, board state, and move history. The `ChessBoardQmlModel` acts as the bridge, exposing properties, lists, and `Q_INVOKABLE` functions to the frontend.
- **Frontend (`QML`)**: Completely declarative UI. The board uses a `GridView` / `Repeater` to draw the 64 squares, dynamically pulling colors, highlights, and SVG piece assets based on the C++ model state.

## 🚀 Getting Started
### Prerequisites
- **C++ 17** compatible compiler (MSVC 2022, GCC, or Clang)
- **Qt 6.x** (Includes Core, Gui, Qml, Quick, QuickControls2 components)
- **CMake 3.16+**

### Building from Source
1. **Clone the repository**:
```
git clone https://github.com/rodofrodo/chess_project.git
cd chess_project
```

2. **Configure with CMake**:
If you are working collaboratively or your Qt installation is in a custom path, **do not** hardcode paths in `CMakeLists.txt`. Instead, create a `CMakeUserPresets.json` file in the root directory:
```json
{
  "version": 3,
  "configurePresets": [
    {
      "name": "local_build",
      "inherits": "Qt",
      "cacheVariables": {
        "CMAKE_PREFIX_PATH": "C:/path/to/your/Qt/6.x/msvc2022_64"
      }
    }
  ]
}
```

3. **Build and Run (CLI)**:
```
mkdir build && cd build
cmake ..
cmake --build .
./chess_project
```
(_Alternatively, just open the project folder in Visual Studio or Qt Creator and select your build preset!_)

## 🛠️ Built With
- **Qt 6** - The cross-platform application framework.
- **C++** - Core logic and engine routing.
- **CMake** - Build system generator.
- **Product Sans** - Core typography used throughout the UI.

## 🤝 Contributing
This is a collaborative project! If you'd like to contribute:
1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

**Important Note for Contributors**: Please ensure `CMakeUserPresets.json` remains in the `.gitignore` to prevent hardcoded local paths from overwriting the main branch.
