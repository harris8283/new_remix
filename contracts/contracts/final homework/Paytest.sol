// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
import "./MYTokenERC1155.sol";

contract ContractB {


    constructor() {
        address contractAInstance=0xfc0722be71b3acfb3170aba424ca9d88454573c7;
    }

    function callPayableFunction(uint amount, uint intValue) external {
        MyTokenERC1155.unlock{value: amount}(intValue);
    }
}