const Token= artifacts.require("MyToken");
const TokenSale = artifacts.require("MyTokenSale");

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
        let balanceBefore = await tokeninstance.balanceOf(deployerAccount);
        
        expect(tokenSaleInstance.sendTransaction({from:deployerAccount,value: web3.utils.toWei("1","wei")})).to.be.fulfilled;

        let balance=await balanceBefore.add(new BN(1));
        return expect(tokeninstance.balanceOf(deployerAccount)).to.eventually.be.a.bignumber.equal(balance);
    })
})