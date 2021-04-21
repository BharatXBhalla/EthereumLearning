var Mytoken = artifacts.require("MyToken.sol");
var MytokenSale=artifacts.require("MyTokenSale");
require("dotenv").config({path:"../.env"});
//process.env

module.exports = async function(deployer) {
    let addr= await web3.eth.getAccounts();
    await deployer.deploy(Mytoken,process.env.INNTIAL_TOKEN); //deploying MyToken

    await deployer.deploy(MytokenSale,1,addr[0],Mytoken.address);

    let instanceMyToken = await Mytoken.deployed();
    await instanceMyToken.transfer(MytokenSale.address ,process.env.INNTIAL_TOKEN);

}