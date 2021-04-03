// SPDX-License-Identifier: MIT
pragma solidity ^0.7.4;

struct Payment{
    uint amount;
    uint timestamp;
}//used for inflow of cash
contract MappingStructExample{
    struct Balance{
        uint totalBalance;
        uint numOfPayments;
        mapping(uint => Payment) payments;
    }
    mapping(address => Balance) public balanceReceived;
    
    function getBalance() public view returns(uint){
        return address(this).balance;
    }
    function sendMoney() public payable {
        balanceReceived[msg.sender].totalBalance+=msg.value;
        Payment memory payment=Payment(msg.value,block.timestamp);
        balanceReceived[msg.sender].payments[balanceReceived[msg.sender].numOfPayments]=payment;
        balanceReceived[msg.sender].numOfPayments+=1;
        
    }
    function withdrawAllMoney(address payable _to) public{
        uint moneyToWithdraw= balanceReceived[msg.sender].totalBalance;
        balanceReceived[msg.sender].totalBalance=0;
        _to.transfer(moneyToWithdraw);
    }
    
    function withdrawMoney(address payable _to, uint amont) public{
        require(balanceReceived[msg.sender].totalBalance>=amont,"Not Suffient Funds");
        balanceReceived[msg.sender].totalBalance-=amont;
        _to.transfer(amont);
    }
}