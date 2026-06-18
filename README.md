♟️ Qt Quick ChessA modern, highly polished local multiplayer Chess application featuring a robust C++ engine backend and a sleek, animated QML frontend.✨ FeaturesComplete Chess Logic: Full support for standard rules, including check, checkmate, stalemate, castling, en passant, and pawn promotion.Modern UI/UX: A responsive, beautifully designed interface utilizing QtQuick and QtQuick.Controls.Smooth Animations: Spring-loaded popups (Easing.OutBack) for Check warnings, Game Over states, and Pawn Promotion.Dynamic Time Controls: Fully functional chess clocks supporting Custom, Rapid, Blitz, and Bullet time controls with increments.Live Match Tracking:Auto-scrolling move history panel.Visual capture boards dynamically scaling based on piece type.Turn indicators.Seamless Navigation: Uses QML StackView architecture for memory-efficient navigation between the Main Menu and the Game Board.📸 Screenshots(Tip: Upload the screenshots you shared earlier directly to your GitHub repo in an /assets folder, then link them here!)Main MenuGameplayGame Over🏗️ ArchitectureThis project strictly adheres to the Model-View architecture, cleanly separating the game logic from the user interface:Backend (C++): The ChessGame class handles all rule validation, board state, and move history. The ChessBoardQmlModel acts as the bridge, exposing properties, lists, and Q_INVOKABLE functions to the frontend.Frontend (QML): Completely declarative UI. The board uses a GridView / Repeater to draw the 64 squares, dynamically pulling colors, highlights, and SVG piece assets based on the C++ model state.🚀 Getting StartedPrerequisitesC++ 17 compatible compiler (MSVC 2022, GCC, or Clang)Qt 6.x (Includes Core, Gui, Qml, Quick, QuickControls2 components)CMake 3.16+Building from SourceClone the repository:Bashgit clone https://github.com/YOUR-USERNAME/YOUR-REPO-NAME.git
cd YOUR-REPO-NAME
Configure with CMake:If you are working collaboratively or your Qt installation is in a custom path, do not hardcode paths in CMakeLists.txt. Instead, create a CMakeUserPresets.json file in the root directory:JSON{
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
Build and Run (CLI):Bashmkdir build && cd build
cmake ..
cmake --build .
./chess_project
(Alternatively, just open the project folder in Visual Studio or Qt Creator and select your build preset!)🛠️ Built WithQt 6 - The cross-platform application framework.C++ - Core logic and engine routing.CMake - Build system generator.Product Sans - Core typography used throughout the UI.🤝 ContributingThis is a collaborative project! If you'd like to contribute:Fork the ProjectCreate your Feature Branch (git checkout -b feature/AmazingFeature)Commit your Changes (git commit -m 'Add some AmazingFeature')Push to the Branch (git push origin feature/AmazingFeature)Open a Pull RequestImportant Note for Contributors: Please ensure CMakeUserPresets.json remains in the .gitignore to prevent hardcoded local paths from overwriting the main branch.
