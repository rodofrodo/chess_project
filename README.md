<img width="7680" height="4320" alt="chess_project_github" src="https://github.com/user-attachments/assets/f2d653f8-5232-4c95-be85-adce011a3229" />

[![C++](https://img.shields.io/badge/C++-%2300599C.svg?logo=c%2B%2B&logoColor=white)](#)
[![Qt](https://img.shields.io/badge/Qt-2CDE85?logo=Qt&logoColor=fff)](#)
[![Figma](https://img.shields.io/badge/Figma-F24E1E?logo=figma&logoColor=white)](#)
[![Markdown](https://img.shields.io/badge/Markdown-%23000000.svg?logo=markdown&logoColor=white)](#)
[![JSON](https://img.shields.io/badge/JSON-000?logo=json&logoColor=fff)](#)
[![Visual Studio](https://custom-icon-badges.demolab.com/badge/Visual%20Studio-5C2D91.svg?&logo=visualstudio&logoColor=white)](#)
[![Visual Studio Code](https://custom-icon-badges.demolab.com/badge/Visual%20Studio%20Code-0078d7.svg?logo=vsc&logoColor=white)](#)

[![GitHub](https://img.shields.io/badge/rodofrodo-black?style=for-the-badge&logo=github&logoColor=white&link=https%3A%2F%2Fgithub.com%2Frodofrodo
)](https://github.com/rodofrodo)
[![BMAC](https://img.shields.io/badge/Buy%20me%20a%20coffee-ffdd00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black&link=https%3A%2F%2Fbuymeacoffee.com%2Fnkbdev)](https://buymeacoffee.com/nkbdev)
[![KOFI](https://img.shields.io/badge/KO--FI-FF5E5B?style=for-the-badge&logo=ko-fi&logoColor=white&link=https%3A%2F%2Fko-fi.com%2Frodofrodo)](https://ko-fi.com/rodofrodo)

## 📜 About
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
<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/59f6abff-0a5f-4d68-acb2-92f71a2cc922" />
<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/4d8b1cec-4e33-495a-864f-060d6c0f01ca" />
<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/fb549204-1d26-4324-9c35-1b9aafb494c8" />
<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/26890e3a-05cb-432b-bb5a-b764af4ce0b9" />
<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/3848db5d-70df-4c26-ae24-7941f8b2c44c" />
<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/cd8b90b2-7fb1-41aa-ad88-b72593533bc5" />
<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/2d6128b6-a85f-4d2c-b459-569f6018a646" />
<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/197a85ad-d40a-449a-8ece-c75bd8a14221" />
<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/45de7f53-67a8-4e5e-9d51-f7eb2891ac23" />
<img width="1918" height="1079" alt="image" src="https://github.com/user-attachments/assets/10dfe6ac-2e7a-4593-a483-8f29caf9904b" />
<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/e31fbfbf-bb90-40c4-93ab-4d3aa1d469db" />
<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/d30f1fa9-77f8-48ce-9e3b-d4f781cae7a9" />
<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/e33821e9-bf14-49ef-9120-944b43f35d68" />
<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/07084c39-3c38-4ad3-b8e1-5c81090fc45c" />


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
