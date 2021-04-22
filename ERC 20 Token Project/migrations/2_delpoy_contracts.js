var Mytoken = artifacts.require("MyToken.sol");
var MytokenSale=artifacts.require("MyTokenSale");
var Kyc=artifacts.require("Kyc");
require("dotenv").config({path:"../.env"});
//process.env

module.exports = async function(deployer) {
    let addr= await web3.eth.getAccounts();
    await deployer.deploy(Mytoken,process.env.INNTIAL_TOKEN); //deploying MyToken
    await deployer.deploy(Kyc);
    await deployer.deploy(MytokenSale,1,addr[0],Mytoken.address,Kyc.address);

    let instanceMyToken = await Mytoken.deployed();
    await instanceMyToken.transfer(MytokenSale.address ,process.env.INNTIAL_TOKEN);

}