// SPDX-License-Identifier: MIT
pragma solidity ^0.7.4;


contract somecontract{
    uint public myunits;
    
    function setMyunits(uint _myunits)public {
        myunits=_myunits;
    }
}