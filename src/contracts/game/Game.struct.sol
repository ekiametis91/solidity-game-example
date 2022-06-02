// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

struct PlayerBet {
    address gamer;
    uint256 betValue;
    uint256 betAt;
    uint256[3] numbers;
    uint256 roundId;
}

struct Round {
    uint256 id;
    uint256[] numbers;
    uint256 reward;
    address payable[] winners;
    uint256 createdAt;
    uint256 finishedAt;
    bool finished;
    PlayerBet[] bets;
}
