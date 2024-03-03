// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Counter {
    uint256 public counter;

    constructor() {
        counter = 0;
    }

    function count() external {
        counter = counter + 1;
    }
}
