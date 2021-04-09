// SPDX-License-Identifier: MIT
pragma solidity ^0.7.4;

import "./Owned.sol";

contract InheritanceExample is owned{
    mapping(address=>uint) public tokenBalance;
    uint tokenPrice=1 ether;
    
    constructor(){
        tokenBalance[owner]=100;
    }
    
    function destory() public onlyOwned{
        selfdestruct(owner);
    }
}