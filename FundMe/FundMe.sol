// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract Fund{
    mapping (address => uint256) public funders2Amount;
    uint256 MIN_VAULE = 100;// * 10 ** 18;
    uint256 constant TARGET_VALUE = 1000;

    address public owner;

    AggregatorV3Interface internal dataFeed;

    /**
    * Network: Sepolia
    * Aggregator: BTC/USD
    * Address: 0x1b44F3514812d835EB1BDB0acB33d3fA3351Ee43
    */
    constructor() {
        //sepolia  testnet
        dataFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        owner = msg.sender;
    }

    function fund() external payable {
        require(convertETH2USDT(msg.value) >= MIN_VAULE,"send more eth");
        // 付款方地址（调用者）
        address payer = msg.sender;
        // 收款方地址（当前合约地址）
        address payee = address(this);

        funders2Amount[msg.sender] = msg.value;

        // 打印日志（Remix 控制台可见）
        emit LogFundTransfer(payer, payee, msg.value);

        // 可选：添加事件定义（在合约外部声明）
    }

    function convertETH2USDT(uint256 ethAmount) internal view returns (uint256) {
        (, int256 ethPrice, , , ) = dataFeed.latestRoundData();
        require(ethPrice > 0, "Chainlink price <= 0");
        return (ethAmount * uint256(ethPrice)) / 10**8; // Chainlink 价格通常带 8 位小数
    }

    //转移owner的所有权
    function transferOwnership(address newOwner) public {
        require(owner == msg.sender,"this function is  only called by owner!");
        owner = newOwner;
    }

    //提款  是从合约地址提取到自己的地址中
    //只能够是厂商自己调用哦，其他人无权限
    function getFund() external {
        //
        require(owner == msg.sender,"this function is  only called by owner!");
        require(convertETH2USDT(address(this).balance) >= TARGET_VALUE, "target is not reached!");
        // payable(msg.sender).transfer(address(this).balance);//把合约中的eth转移给厂商自己

        //send: transfer eth and return false if failed!
        // bool success = payable(msg.sender).send(address(this).balance);
        // require(success, "transaction is failed!");

        bool success;
        (success,) =  payable(msg.sender).call{value:address(this).balance}("");
        require(success,"transaction is failed!");
        funders2Amount[msg.sender] = 0;
    }

    //退款
    function reFund() external {
        require(convertETH2USDT(address(this).balance) < TARGET_VALUE, "target is reached!"); 
        require(funders2Amount[msg.sender] !=0 , "no fund from you!");
        bool success;
        (success,) =  payable(msg.sender).call{value: funders2Amount[msg.sender]}(""); 
        require(success,"transaction is failed!");
        funders2Amount[msg.sender] = 0;//交易成功后清零，否则可以多次退款哦
    }

    // 事件定义（添加到合约内，与 `fund` 函数同级）
    event LogFundTransfer(address indexed from, address indexed to, uint256 amount);
}