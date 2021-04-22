const Token= artifacts.require("MyToken");
const TokenSale = artifacts.require("MyTokenSale");
const Kyc=artifacts.require("Kyc");
const chai=require("./setupChai.js");
const BN=web3.utils.BN;
const expect=chai.expect;

require("dotenv").config({path:"../.env"});

contract("MyTokenSale Test", async(accounts)=>{

    const[deployerAccount,recipient,anotherAccount]=accounts;

    it("Deployer should have zero token", async() =>{
        let instance = await Token.deployed();
        return expect(instance.balanceOf(deployerAccount)).to.eventually.be.a.bignumber.equal(new BN(0));
    });

    it("all tokens should be in the TokenSale Smart Contract by defualt ",async()=>{
        let instance = await Token.deployed();
        let tokeninstance = await TokenSale.deployed();
        return expect(instance.balanceOf(tokeninstance.address)).to.eventually.be.a.bignumber.equal(await instance.totalSupply());

    })
    it("shoudl be possible to buy token", async()=>{
        let tokeninstance = await Token.deployed();
        let tokenSaleInstance = await TokenSale.deployed();
        let kycInstance=await Kyc.deployed();
        let balanceBefore = await tokeninstance.balanceOf(anotherAccount);
        let res1=await kycInstance.setKycCompleted(deployerAccount,{from: deployerAccount});
        let isAuth = await kycInstance.kycCompleted(deployerAccount);
        console.log(res1);
        console.log(isAuth);
        let res=await tokenSaleInstance.sendTransaction({from:anotherAccount,value: web3.utils.toWei("1","wei")});
        console.log(res);
        let balance=await balanceBefore.add(new BN(1));
        let balanceinwallet=await tokeninstance.balanceOf(anotherAccount);
        if(balance===balanceinwallet){
            console.log("Yes");
        }else{
            return Error("Not Equal");
        }
        return;
    })
})