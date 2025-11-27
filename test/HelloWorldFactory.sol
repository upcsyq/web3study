//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { HelloWorld } from "./test.sol";

contract HelloWorldFactory{
    HelloWorld hw;
    HelloWorld[] hws;

    function createHelloWorld() public {
        hw = new HelloWorld();
        hws.push(hw);
    }

    function getHelloWorldByIngex(uint256 index) 
        public view returns (HelloWorld){
        return hws[index];
    }

    function callSayHelloWorldFromFactory(uint256 index, uint256 _id) 
        public view returns (string memory) {
        return hws[index].sayHello(_id);
    }

    function setSayHelloWorldFromFactory(uint256 index, string memory _str, uint256 _id) public {
        hws[index].setHelloWorld(_str, _id);
    }
    
}
