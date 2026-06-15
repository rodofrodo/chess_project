#include "ChessClock.h"
#include <algorithm>

ChessClock::ChessClock()
    : whiteTimeMs(0), blackTimeMs(0), incrementMs(0), currentTurn(Color::White), isRunning(false) {
}

void ChessClock::start(int minutes, int incrementSeconds) {
    long long timeMs = static_cast<long long>(minutes) * 60 * 1000;
    incrementMs = static_cast<long long>(incrementSeconds) * 1000;
    
    whiteTimeMs = timeMs;
    blackTimeMs = timeMs;
    currentTurn = Color::White;
    isRunning = true;
    lastTick = std::chrono::steady_clock::now();
}

void ChessClock::switchTurn() {
    if (!isRunning) return;

    tick(); // Update time before switching

    if (currentTurn == Color::White) {
        whiteTimeMs += incrementMs;
        currentTurn = Color::Black;
    } else {
        blackTimeMs += incrementMs;
        currentTurn = Color::White;
    }
    
    lastTick = std::chrono::steady_clock::now();
}

void ChessClock::tick() {
    if (!isRunning) return;

    auto now = std::chrono::steady_clock::now();
    auto elapsedMs = std::chrono::duration_cast<std::chrono::milliseconds>(now - lastTick).count();
    lastTick = now;

    if (currentTurn == Color::White) {
        whiteTimeMs = std::max(0LL, whiteTimeMs - elapsedMs);
        if (whiteTimeMs == 0) isRunning = false;
    } else {
        blackTimeMs = std::max(0LL, blackTimeMs - elapsedMs);
        if (blackTimeMs == 0) isRunning = false;
    }
}

long long ChessClock::getWhiteTimeMs() const {
    if (!isRunning || currentTurn != Color::White) {
        return std::max(0LL, whiteTimeMs);
    }
    
    auto now = std::chrono::steady_clock::now();
    auto elapsedMs = std::chrono::duration_cast<std::chrono::milliseconds>(now - lastTick).count();
    return std::max(0LL, whiteTimeMs - elapsedMs);
}

long long ChessClock::getBlackTimeMs() const {
    if (!isRunning || currentTurn != Color::Black) {
        return std::max(0LL, blackTimeMs);
    }
    
    auto now = std::chrono::steady_clock::now();
    auto elapsedMs = std::chrono::duration_cast<std::chrono::milliseconds>(now - lastTick).count();
    return std::max(0LL, blackTimeMs - elapsedMs);
}

bool ChessClock::isTimeOut(Color color) const {
    if (color == Color::White) {
        return getWhiteTimeMs() == 0;
    } else {
        return getBlackTimeMs() == 0;
    }
}
