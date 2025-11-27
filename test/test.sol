//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
//comment: this is my first smart contract
contract HelloWorld{
    string  strVar = "hello world";//动态大小的bytes

    struct Info{
        string pharse;
        uint256 id;
        address addr;
    }

    mapping (uint256 id =>Info info) infoMapping;

    function sayHello(uint256 _id) public view  returns(string memory){
        if(infoMapping[_id].addr == address(0x0)){
            return addInfo(strVar);
        }
        
        return addInfo(infoMapping[_id].pharse);
    }

    function setHelloWorld(string memory _str, uint256 _id) public {
        Info memory info = Info(_str,_id,msg.sender);
        infoMapping[_id] = info;
    }

    function addInfo(string memory str) internal pure returns (string memory) {
        return string.concat(str, " from jacky's smart contract!");
    }
}
