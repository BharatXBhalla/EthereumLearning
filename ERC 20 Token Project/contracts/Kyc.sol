pragma solidity 0.6.1;

import "@openzeppelin/contracts/ownership/Ownable.sol";

contract Kyc is Ownable{
    mapping(address=> bool) allowed;
    event SettedKyc(address whom);
    event KycBoolean(address whom,bool isAuth);

    function setKycCompleted(address _addr) public onlyOwner{
        allowed[_addr]=true;
        emit SettedKyc(_addr);
    }

    function setKycRevoked(address _addr) public onlyOwner{
        allowed[_addr]=false;
    }
    function kycCompleted(address _addr) public view returns(bool){
        return allowed[_addr];
    }
}