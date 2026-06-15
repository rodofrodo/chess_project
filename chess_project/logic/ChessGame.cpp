#include "ChessGame.h"
#include "Pieces.h"
#include <cmath>

ChessGame::ChessGame() {
    setupBoard();
    gameState = GameState::WaitingForStart;
}

const std::vector<MoveRecord>& ChessGame::getMoveHistory() const {
    return moveHistory;
}

const std::vector<PieceType>& ChessGame::getWhiteCapturedPieces() const {
    return whiteCapturedPieces;
}

const std::vector<PieceType>& ChessGame::getBlackCapturedPieces() const {
    return blackCapturedPieces;
}

std::shared_ptr<Piece> ChessGame::getPieceAt(int row, int col) const {
    if (row >= 0 && row < 8 && col >= 0 && col < 8) return board[row][col];
    return nullptr;
}

bool ChessGame::isHighlighted(int row, int col) const {
    for (const auto& m : highlightedMoves) if (m.row == row && m.col == col) return true;
    return false;
}

GameState ChessGame::getGameState() const {
    return gameState;
}

void ChessGame::startGame(int totalMinutes, int incrementSeconds) {
    setupBoard();
    currentTurn = Color::White;
    enPassantTarget = { -1, -1 };
    pendingPromotion = { -1, -1 };
    selectedRow = -1;
    selectedCol = -1;
    highlightedMoves.clear();
    moveHistory.clear();
    whiteCapturedPieces.clear();
    blackCapturedPieces.clear();
    gameState = GameState::Active;
    clock.start(totalMinutes, incrementSeconds);
}

void ChessGame::updateClock() {
    if (gameState != GameState::Active) return;
    clock.tick();
    if (clock.isTimeOut(Color::White)) {
        gameState = GameState::TimeOutWhite;
    } else if (clock.isTimeOut(Color::Black)) {
        gameState = GameState::TimeOutBlack;
    }
}

const ChessClock& ChessGame::getClock() const {
    return clock;
}

void ChessGame::setupBoard() {
    board.assign(8, std::vector<std::shared_ptr<Piece>>(8, nullptr));
    auto setupRow = [&](int row, Color color) {
        board[row][0] = std::make_shared<Rook>(color, Position{ row, 0 });
        board[row][1] = std::make_shared<Knight>(color, Position{ row, 1 });
        board[row][2] = std::make_shared<Bishop>(color, Position{ row, 2 });
        board[row][3] = std::make_shared<Queen>(color, Position{ row, 3 });
        board[row][4] = std::make_shared<King>(color, Position{ row, 4 });
        board[row][5] = std::make_shared<Bishop>(color, Position{ row, 5 });
        board[row][6] = std::make_shared<Knight>(color, Position{ row, 6 });
        board[row][7] = std::make_shared<Rook>(color, Position{ row, 7 });
        };

    setupRow(0, Color::Black);
    setupRow(7, Color::White);

    for (int i = 0; i < 8; ++i) {
        board[1][i] = std::make_shared<Pawn>(Color::Black, Position{ 1, i });
        board[6][i] = std::make_shared<Pawn>(Color::White, Position{ 6, i });
    }
}

bool ChessGame::isSquareAttacked(Position pos, Color attackerColor) const {
    for (int r = 0; r < 8; ++r) {
        for (int c = 0; c < 8; ++c) {
            if (board[r][c] && board[r][c]->getColor() == attackerColor) {
                if (board[r][c]->getType() == PieceType::Pawn) {
                    int dir = (attackerColor == Color::White) ? -1 : 1;
                    if (pos.row == r + dir && (pos.col == c - 1 || pos.col == c + 1)) return true;
                }
                else {
                    auto moves = board[r][c]->getValidMoves(board);
                    for (auto m : moves) if (m == pos) return true;
                }
            }
        }
    }
    return false;
}

bool ChessGame::isCheck(Color kingColor) const {
    Position kingPos{ -1, -1 };
    for (int r = 0; r < 8; ++r) {
        for (int c = 0; c < 8; ++c) {
            if (board[r][c] && board[r][c]->getType() == PieceType::King && board[r][c]->getColor() == kingColor) {
                kingPos = { r, c };
                break;
            }
        }
    }
    return isSquareAttacked(kingPos, (kingColor == Color::White) ? Color::Black : Color::White);
}

std::vector<Position> ChessGame::getLegalMoves(std::shared_ptr<Piece> piece) {
    auto rawMoves = piece->getValidMoves(board);
    std::vector<Position> legalMoves;
    Color enemyColor = (piece->getColor() == Color::White) ? Color::Black : Color::White;
    int r = piece->getPosition().row;
    int c = piece->getPosition().col;

    if (piece->getType() == PieceType::Pawn && enPassantTarget.row != -1) {
        int dir = piece->getColor() == Color::White ? -1 : 1;
        if (r == enPassantTarget.row - dir && std::abs(c - enPassantTarget.col) == 1) {
            rawMoves.push_back(enPassantTarget);
        }
    }

    if (piece->getType() == PieceType::King && !piece->getHasMoved() && !isCheck(piece->getColor())) {
        if (!board[r][5] && !board[r][6]) {
            auto rook = board[r][7];
            if (rook && rook->getType() == PieceType::Rook && !rook->getHasMoved()) {
                if (!isSquareAttacked({ r, 5 }, enemyColor) && !isSquareAttacked({ r, 6 }, enemyColor)) rawMoves.push_back({ r, 6 });
            }
        }
        if (!board[r][1] && !board[r][2] && !board[r][3]) {
            auto rook = board[r][0];
            if (rook && rook->getType() == PieceType::Rook && !rook->getHasMoved()) {
                if (!isSquareAttacked({ r, 2 }, enemyColor) && !isSquareAttacked({ r, 3 }, enemyColor)) rawMoves.push_back({ r, 2 });
            }
        }
    }

    for (auto move : rawMoves) {
        auto destPiece = board[move.row][move.col];
        std::shared_ptr<Piece> epPiece = nullptr;
        if (piece->getType() == PieceType::Pawn && move == enPassantTarget) {
            epPiece = board[r][move.col];
            board[r][move.col] = nullptr;
        }

        board[move.row][move.col] = piece;
        board[r][c] = nullptr;
        piece->setPosition(move);

        if (!isCheck(piece->getColor())) legalMoves.push_back(move);

        piece->setPosition({ r, c });
        board[r][c] = piece;
        board[move.row][move.col] = destPiece;
        if (epPiece) board[r][move.col] = epPiece;
    }
    return legalMoves;
}

void ChessGame::selectSquare(int row, int col) {
    if (gameState != GameState::Active && gameState != GameState::Promotion) return;

    if (selectedRow == -1 && selectedCol == -1) {
        if (board[row][col] && board[row][col]->getColor() == currentTurn) {
            selectedRow = row; selectedCol = col;
            highlightedMoves = getLegalMoves(board[row][col]);
        }
    }
    else {
        bool isValid = false;
        for (auto m : highlightedMoves) if (m.row == row && m.col == col) isValid = true;

        if (isValid) {
            auto piece = board[selectedRow][selectedCol];
            bool isCapture = (board[row][col] != nullptr) || (piece->getType() == PieceType::Pawn && row == enPassantTarget.row && col == enPassantTarget.col);
            bool isCastling = (piece->getType() == PieceType::King && std::abs(selectedCol - col) == 2);
            Color movingColor = currentTurn;
            std::string moveStr = toAlgebraic(piece, {selectedRow, selectedCol}, {row, col}, isCapture, isCastling);

            std::shared_ptr<Piece> capturedPiece = nullptr;
            if (isCapture) {
                if (board[row][col] != nullptr) {
                    capturedPiece = board[row][col];
                } else {
                    capturedPiece = board[selectedRow][col];
                }
            }
            if (capturedPiece) {
                if (movingColor == Color::White) {
                    whiteCapturedPieces.push_back(capturedPiece->getType());
                } else {
                    blackCapturedPieces.push_back(capturedPiece->getType());
                }
            }

            movePiece(selectedRow, selectedCol, row, col);
            if (gameState != GameState::Promotion) {
                if (movingColor == Color::White) {
                    moveHistory.push_back({moveStr, ""});
                } else {
                    if (!moveHistory.empty()) moveHistory.back().blackMove = moveStr;
                }
                
                currentTurn = (currentTurn == Color::White) ? Color::Black : Color::White;
                clock.switchTurn();
                updateGameState();
            }
        }

        selectedRow = -1; selectedCol = -1;
        highlightedMoves.clear();

        if (!isValid && board[row][col] && board[row][col]->getColor() == currentTurn) {
            selectedRow = row; selectedCol = col;
            highlightedMoves = getLegalMoves(board[row][col]);
        }
    }
}

void ChessGame::movePiece(int fromRow, int fromCol, int toRow, int toCol) {
    auto piece = board[fromRow][fromCol];
    bool isPawn = (piece->getType() == PieceType::Pawn);
    bool isKing = (piece->getType() == PieceType::King);

    if (isPawn && toRow == enPassantTarget.row && toCol == enPassantTarget.col) {
        board[fromRow][toCol] = nullptr;
    }

    if (isPawn && std::abs(fromRow - toRow) == 2) enPassantTarget = { (fromRow + toRow) / 2, fromCol };
    else enPassantTarget = { -1, -1 };

    if (isKing && std::abs(fromCol - toCol) == 2) {
        if (toCol == 6) {
            board[fromRow][5] = board[fromRow][7];
            board[fromRow][5]->setPosition({ fromRow, 5 });
            board[fromRow][7] = nullptr;
        }
        else if (toCol == 2) {
            board[fromRow][3] = board[fromRow][0];
            board[fromRow][3]->setPosition({ fromRow, 3 });
            board[fromRow][0] = nullptr;
        }
    }

    piece->setPosition({ toRow, toCol });
    piece->markAsMoved();
    board[toRow][toCol] = piece;
    board[fromRow][fromCol] = nullptr;

    if (isPawn && (toRow == 0 || toRow == 7)) {
        gameState = GameState::Promotion;
        pendingPromotion = { toRow, toCol };
    }
}

void ChessGame::promotePawn(PieceType type) {
    if (gameState != GameState::Promotion) return;

    auto pawn = board[pendingPromotion.row][pendingPromotion.col];
    Color c = pawn->getColor();

    if (type == PieceType::Queen) board[pendingPromotion.row][pendingPromotion.col] = std::make_shared<Queen>(c, pendingPromotion);
    else if (type == PieceType::Rook) board[pendingPromotion.row][pendingPromotion.col] = std::make_shared<Rook>(c, pendingPromotion);
    else if (type == PieceType::Bishop) board[pendingPromotion.row][pendingPromotion.col] = std::make_shared<Bishop>(c, pendingPromotion);
    else if (type == PieceType::Knight) board[pendingPromotion.row][pendingPromotion.col] = std::make_shared<Knight>(c, pendingPromotion);

    std::string promoChar = "Q";
    if (type == PieceType::Rook) promoChar = "R";
    else if (type == PieceType::Bishop) promoChar = "B";
    else if (type == PieceType::Knight) promoChar = "N";
    
    std::string moveStr = std::string(1, 'a' + pendingPromotion.col) + std::to_string(8 - pendingPromotion.row) + "=" + promoChar;
    if (currentTurn == Color::White) {
        moveHistory.push_back({moveStr, ""});
    } else {
        if (!moveHistory.empty()) moveHistory.back().blackMove = moveStr;
    }

    pendingPromotion = { -1, -1 };
    gameState = GameState::Active;

    currentTurn = (currentTurn == Color::White) ? Color::Black : Color::White;
    clock.switchTurn();
    updateGameState();
}

void ChessGame::updateGameState() {
    bool hasAnyLegalMove = false;
    for (int r = 0; r < 8; ++r) {
        for (int c = 0; c < 8; ++c) {
            if (board[r][c] && board[r][c]->getColor() == currentTurn) {
                if (!getLegalMoves(board[r][c]).empty()) {
                    hasAnyLegalMove = true;
                    break;
                }
            }
        }
        if (hasAnyLegalMove) break;
    }

    if (!hasAnyLegalMove) {
        if (isCheck(currentTurn)) gameState = (currentTurn == Color::White) ? GameState::BlackWins : GameState::WhiteWins;
        else gameState = GameState::Stalemate;
    }
}

std::string ChessGame::toAlgebraic(std::shared_ptr<Piece> piece, Position from, Position to, bool isCapture, bool isCastling) {
    if (isCastling) {
        if (to.col == 6) return "O-O";
        if (to.col == 2) return "O-O-O";
    }
    
    std::string dest = std::string(1, 'a' + to.col) + std::to_string(8 - to.row);
    if (piece->getType() == PieceType::Pawn) {
        if (isCapture) {
            return std::string(1, 'a' + from.col) + "x" + dest;
        }
        return dest;
    }
    
    std::string prefix = "";
    switch (piece->getType()) {
        case PieceType::Knight: prefix = "N"; break;
        case PieceType::Bishop: prefix = "B"; break;
        case PieceType::Rook: prefix = "R"; break;
        case PieceType::Queen: prefix = "Q"; break;
        case PieceType::King: prefix = "K"; break;
        default: break;
    }
    
    if (isCapture) {
        return prefix + "x" + dest;
    }
    return prefix + dest;
}