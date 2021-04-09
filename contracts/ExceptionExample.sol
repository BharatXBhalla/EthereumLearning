// SPDX-License-Identifier: MIT
pragma solidity ^0.7.4;


contract ExceptionExample{
    
    mapping(address=>uint64) public balanceReceived;
    
    function totalBalanceInContract() public view returns(uint){
        return address(this).balance;
    }
    
    function recievedMoney() public payable{
        assert(uint64(msg.value)==msg.value);
        assert(balanceReceived[msg.sender]+ uint64(msg.value) >= balanceReceived[msg.sender]);
        balanceReceived[msg.sender]+=uint64(msg.value);
    }
    
    
    //if i have used uint instead of uint64 then it would be manadorty to keep checks before ductions.
    
    function withdraw(address payable _to,uint64 _amount) public{
        require(_amount<=balanceReceived[msg.sender],"Not enough balance");
        balanceReceived[msg.sender]-=_amount;
        _to.transfer(_amount);
    }
}