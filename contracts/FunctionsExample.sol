// SPDX-License-Identifier: MIT
pragma solidity ^0.7.4;

contract FunctionsExample {
    mapping(address=>uint) public balancedReceived;
    
    address payable public owner ;
    
    constructor() payable{
        owner=msg.sender;
    }
    
    function getConversions(uint weis) public pure returns(uint){
        return(weis/ 1 ether);
    }
    
    function getOwner() public view returns(address){
        return owner;
    }
    function destroyContract() public{
        require(msg.sender==owner,"Owner can only call");
        selfdestruct(owner);
    }
    
    function recieveMoney() public payable{
        assert(balancedReceived[msg.sender] + msg.value >= balancedReceived[msg.sender]);
        balancedReceived[msg.sender]+=msg.value;
    }
    function withdrawMoney(address payable to,uint amount) public {
        require(amount <= balancedReceived[msg.sender]);
        balancedReceived[msg.sender]-=amount;
        to.transfer(amount);
    }
    
    fallback () external payable{
        recieveMoney();
    }
}