// SPDX-License-Identifier: MIT
pragma solidity ^0.7.4;

contract SendMoneyExample{
    uint public balanceReceived;
    
    function recieveMoney() public payable{
        balanceReceived+= msg.value;
    }
    function getBalance() public view returns(uint){
        return address(this).balance;
    }
    function withdrawlMoney() public {
        address payable to = msg.sender;
        to.transfer(this.getBalance());
    }
    function withdrawlMoneyTo(address payable _to) public {
        _to.transfer(this.getBalance());
    }
}
