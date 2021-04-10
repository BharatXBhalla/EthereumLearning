// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol';


/*
In this Wallet Contract a Parent can Control their Allowances to their children.
Parent can withdrawl any amt of money.
While Child is bound to limit.
Limit can be changed Dynamuically 
*/


contract Allowances is Ownable{
    
    using SafeMath for uint; 
    
    mapping(address=>uint) allowances;
    event AllowanceChanged(address indexed forWho,address indexed fromWhom,uint oldAllownace,uint newAllowance);
    
    function addAllowances(address _to,uint _amt) public onlyOwner{
        emit AllowanceChanged(_to,msg.sender,allowances[_to],_amt);
        allowances[_to]=_amt;
    }
    
    function isOwner() public view returns(bool){
        return msg.sender == owner() ? true : false;
    }
     function reduceAllowance(address _to,uint _amt) internal{
        emit AllowanceChanged(_to,msg.sender,allowances[_to],allowances[_to].sub(_amt));
        allowances[_to]=allowances[_to].sub(_amt);
    }
        modifier ownerOrAllowed(uint _amt){
        require(isOwner() || allowances[msg.sender] >= _amt ,"You are not Allowed");
        _;
    }

    
}

contract SimpleWallet is Allowances{
    
    event MoneyTransfered(address _beneficary,uint _amt);
    event MoneyRecieved(address _from,uint amt);
    
    function balanceContract() public view returns(uint256){
        return address(this).balance;
    }
    
     function renounceOwnership() public pure override(Ownable){
         revert("Sorry Functionality Not Avialable");
    }
  
    function withdrawl(address payable _to,uint256 amt) public ownerOrAllowed(amt){
        require(amt<= address(this).balance,"Not Suffient Funds in Contract");
        if(!isOwner()){
            reduceAllowance(msg.sender,amt);
        }
        emit MoneyTransfered(_to,amt);
        _to.transfer(amt);
    }
    fallback () external payable{
        emit MoneyRecieved(msg.sender,msg.value);
    }
    
}