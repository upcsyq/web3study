// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Parent{
    uint256 public a;

    function addOne() public {
        a++;
    }
}

contract Child{
    uint256 public a;

    function addOne() public {
        a++;
    }

    function addTwo() public {
        a += 2;
    }
}
