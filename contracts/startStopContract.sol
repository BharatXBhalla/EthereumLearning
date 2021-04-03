// SPDX-License-Identifier: MIT
pragma solidity ^0.7.4;


contract startStopContract{
    
    address payable owner;
    bool public paused;
    
    constructor(){
        owner = msg.sender;
    }
    
    function sendMoney() public payable{
        
    }
    
    function withdrawMoney(address payable _to) public{
        require(msg.sender==owner,"Only Owner has permissions");
        require(!paused,"withdrawMoney is paused");
        _to.transfer(address(this).balance);
    }
    function getBalance() public view returns(uint){
        return address(this).balance;
    }
    function setPauseContract(bool _paused) public{
        require(msg.sender==owner,"Only Owner has permissions");
        paused=_paused;
    }
    function destory() public{
        require(msg.sender==owner,"Only Owner has permissions");
        selfdestruct(owner);
    }
}