// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

library Number {
    function random(uint256 _maxValue, uint256 _n1)
        internal
        pure
        returns (uint256)
    {
        return getRrandom(_maxValue, _n1, 0, 0);
    }

    function random(
        uint256 _maxValue,
        uint256 _n1,
        uint256 _n2
    ) internal pure returns (uint256) {
        return getRrandom(_maxValue, _n1, _n2, 0);
    }

    function random(
        uint256 _maxValue,
        uint256 _n1,
        uint256 _n2,
        uint256 _n3
    ) internal pure returns (uint256) {
        return getRrandom(_maxValue, _n1, _n2, _n3);
    }

    function getRrandom(
        uint256 _maxValue,
        uint256 _n1,
        uint256 _n2,
        uint256 _n3
    ) private pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(_n1, _n2, _n3))) % _maxValue;
    }
}
