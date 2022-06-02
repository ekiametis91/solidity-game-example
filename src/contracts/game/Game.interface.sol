// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import {PlayerBet, Round} from "./Game.struct.sol";
import {Number} from "../utils/Number.utils.sol";

interface IGame {
    function createRound() external;

    function bet(
        uint256 _number1,
        uint256 _number2,
        uint256 _number3
    ) external payable;

    function finishRound() external payable;
}

abstract contract AbstractGame is IGame {
    uint256 minNumber;
    uint256 maxNumber;
    uint256 public roundCount;
    address payable owner;
    mapping(uint256 => Round) public rounds;

    event RoundCreated(uint256 roundId, uint256 createdAt, bool finished);

    event RoundFinished(
        uint256 roundId,
        uint256 createdAt,
        uint256 finishedAt,
        bool finished,
        uint256[] numbers,
        address payable[] winners
    );

    event BetCreated(
        uint256 roundId,
        uint256 createdAt,
        bool finished,
        address gamer,
        uint256 betValue,
        uint256 betAt,
        uint256[3] numbers
    );

    /**
     ********************
     * INTERNAL FUNTIONS
     ********************
     */

    function getRandomNumber(uint256 _num, uint256 _maxValue)
        internal
        view
        returns (uint256)
    {
        return
            Number.random(_maxValue, _num, block.difficulty, block.timestamp);
    }

    function checkBet(
        uint256 _betValue,
        uint256 _number1,
        uint256 _number2,
        uint256 _number3
    ) internal pure {
        require(_betValue == (1 ether), "Bet value must be 1");
        require(
            _number1 > 0 && _number1 <= 60,
            "Number 1 should be between 1 and 60"
        );
        require(
            _number2 > 0 && _number2 <= 60,
            "Number 2 should be between 1 and 60"
        );
        require(
            _number3 > 0 && _number3 <= 60,
            "Number 3 should be between 1 and 60"
        );
        require(
            _number1 != _number2 &&
                _number1 != _number3 &&
                _number2 != _number3,
            "Numbers must not be equal"
        );
    }

    function getRoundWinners(Round memory _round)
        internal
        pure
        returns (address payable[] memory)
    {
        address payable[] memory _winners = new address payable[](0);
        uint256 winnerCount = 0;
        uint256 _maxBets = _round.bets.length;
        uint256 _maxNumbers = _round.numbers.length;

        for (uint256 i = 0; i < _maxBets - 1; i++) {
            PlayerBet memory _bet = _round.bets[i];
            uint256 _matchesCount = 0;

            for (uint256 j = 0; j < _maxNumbers - 1; j++) {
                uint256 _number = _round.numbers[j];
                bool _contains = betContainsNumber(_bet, _number);

                if (_contains) {
                    _matchesCount++;
                }
            }

            if (_matchesCount == _maxNumbers) {
                _winners[winnerCount] = payable(_bet.gamer);
                winnerCount++;
            }
        }

        return _winners;
    }

    function betContainsNumber(PlayerBet memory _bet, uint256 _number)
        internal
        pure
        returns (bool)
    {
        for (uint256 i = 0; i < _bet.numbers.length - 1; i++) {
            uint256 _currentNumber = _bet.numbers[i];
            if (_currentNumber == _number) {
                return true;
            }
        }

        return false;
    }

    /**
     ********************
     * MODIFIER FUNTIONS
     ********************
     */

    modifier verifyContractOwner(string memory _msg) {
        require(msg.sender == owner, _msg);
        _; // Execute the logic of the caller method after the verification above
    }
}
