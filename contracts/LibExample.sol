// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol';


contract LibExample{
    //using SafeMath for uint;
    mapping(address => uint) public tokenBalance;
    
    constructor(){
        tokenBalance[msg.sender]=1;
    }
    
    function sendToken(address _to,uint amt) public payable{
        tokenBalance[msg.sender] -=amt;
        tokenBalance[_to]+=amt;
    }
}

//no longer needed for solidity 0.8.0