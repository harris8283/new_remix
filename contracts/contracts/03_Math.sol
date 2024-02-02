// SPDX-License-Identifier: MIT

/**
多型會按照輸入的類型決定用哪一種
*/


pragma solidity 0.8.19;

library math {
    function add(int a, int b) public pure returns (int c) {
        return a + b;
    }

    function add(uint a, uint b) public pure returns (uint c) {
        return a + b;
    }
}