#pragma once
#include <chrono>
#include "Types.h"

// klasa odpowadająca za zegar
class ChessClock {
public:
    ChessClock();

    void start(int minutes, int incrementSeconds);
    void switchTurn();
    void tick();
    long long getWhiteTimeMs() const;
    long long getBlackTimeMs() const;
    bool isTimeOut(Color color) const;
private:
    std::chrono::steady_clock::time_point lastTick;
    
    long long whiteTimeMs;
    long long blackTimeMs;
    long long incrementMs;
    Color currentTurn;
    bool isRunning;
};
