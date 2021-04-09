// SPDX-License-Identifier: MIT
pragma solidity ^0.7.4;

contract owned{
    address payable public owner;
    constructor(){
        owner=msg.sender;
    }
    modifier onlyOwned{
        require(msg.sender == owner,"only owner can call");
        _;
    }
}