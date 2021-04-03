// SPDX-License-Identifier: MIT
pragma solidity ^0.7.4;

contract simpleMappingExample{
    mapping(uint => bool) public mymapping ; 
    //this can be used to set permission matrix    
    function setmapping(uint index) public{
        mymapping[index]=true;
        
    }
    
}