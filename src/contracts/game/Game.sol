// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import {AbstractGame} from "./Game.interface.sol";
import {PlayerBet, Round} from "./Game.struct.sol";

contract Game is AbstractGame {
    constructor() {
        roundCount = 0;
        minNumber = 1;
        maxNumber = 60;
        owner = payable(msg.sender);
    }

    function createRound()
        external
        verifyContractOwner(
            "The caller of the transaction must be the contract owner"
        )
    {
        if (roundCount > 0) {
            require(
                rounds[roundCount].finished,
                "Previous round must be finished"
            );
        }

        roundCount++;
        rounds[roundCount].id = roundCount;
        rounds[roundCount].numbers = new uint256[](3);
        rounds[roundCount].reward = 0;
        rounds[roundCount].winners = new address payable[](0);
        rounds[roundCount].createdAt = block.timestamp;
        rounds[roundCount].finished = false;

        emit RoundCreated(
            rounds[roundCount].id,
            rounds[roundCount].createdAt,
            rounds[roundCount].finished
        );
    }

    function bet(
        uint256 _number1,
        uint256 _number2,
        uint256 _number3
    ) external payable {
        checkBet(msg.value, _number1, _number2, _number3);

        PlayerBet memory _bet = PlayerBet(
            msg.sender,
            msg.value,
            block.timestamp,
            [_number1, _number2, _number3],
            roundCount
        );

        rounds[roundCount].bets.push(_bet);

        rounds[roundCount].reward += msg.value;

        owner.transfer(msg.value);

        emit BetCreated(
            rounds[roundCount].id,
            rounds[roundCount].createdAt,
            rounds[roundCount].finished,
            _bet.gamer,
            _bet.betValue,
            _bet.betAt,
            _bet.numbers
        );
    }

    function finishRound()
        external
        payable
        verifyContractOwner(
            "The caller of the transaction must be the contract owner"
        )
    {
        uint256 _random1 = 0;
        uint256 _random2 = 0;
        uint256 _random3 = 0;

        while (
            _random1 == _random2 || _random1 == _random3 || _random2 == _random3
        ) {
            _random1 = getRandomNumber(1, maxNumber);
            _random2 = getRandomNumber(2, maxNumber);
            _random3 = getRandomNumber(3, maxNumber);
        }
        rounds[roundCount].numbers = [_random1, _random2, _random3];
        rounds[roundCount].winners = getRoundWinners(rounds[roundCount]);
        rounds[roundCount].finishedAt = block.timestamp;
        rounds[roundCount].finished = true;

        address payable[] memory _winners = rounds[roundCount].winners;
        if (_winners.length > 0) {
            uint256 _reward = rounds[roundCount].reward;
            uint256 _rewardForEachUser = _reward / _winners.length;

            for (uint256 i = 0; i < _winners.length - 1; i++) {
                address payable _winner = _winners[i];
                _winner.transfer(_rewardForEachUser);
            }
        }

        emit RoundFinished(
            rounds[roundCount].id,
            rounds[roundCount].createdAt,
            rounds[roundCount].finishedAt,
            rounds[roundCount].finished,
            rounds[roundCount].numbers,
            _winners
        );
    }
}
