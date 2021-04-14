// SPDX-License-Identifier: MIT
pragma solidity ^0.7.4;

contract Ownerable{
    address public owner;
    constructor(){
        owner=msg.sender;
    }
    modifier onlyOwner(){
        require(msg.sender == owner , "You are not Owner");
        _;
    }
    function isOwner() public view returns(bool){
        return(msg.sender == owner);
    }
}