// SPDX-License-Identifier: MIT
pragma solidity ^0.7.4;


contract EventsExample{
    
    mapping(address=>uint) public tokenBalance;
    
    event TokenSend(address _from,address _to,uint amt);
    constructor(){
        tokenBalance[msg.sender]=100;
    }
    
    function sendTokens(address _to,uint _amount) public returns(bool){

        require(tokenBalance[msg.sender] >= _amount, "Not enough tokens");
        assert(tokenBalance[_to] + _amount >= tokenBalance[_to]);
        assert(tokenBalance[msg.sender] - _amount <= tokenBalance[msg.sender]);
        tokenBalance[msg.sender] -= _amount;
        tokenBalance[_to] += _amount;
 
        emit TokenSend(msg.sender,_to,_amount);
        
        return true;
         
        
    }
}