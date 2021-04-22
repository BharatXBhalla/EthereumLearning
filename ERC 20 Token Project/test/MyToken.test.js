const Token= artifacts.require("MyToken");


const chai=require("./setupChai.js");
const BN=web3.utils.BN;
const expect=chai.expect;

require("dotenv").config({path:"../.env"});

contract("Token Test", async(accounts)=>{

    const[deployerAccount,recipient,anotherAccount]=accounts;

    beforeEach(async ()=>{
        return this.myTokenInstance= await Token.new(process.env.INNTIAL_TOKEN);
    });

    it("all tokens should be in my account",async ()=>{
        let instance =  this.myTokenInstance;
        let totalSupply = await instance.totalSupply();
        return expect(await instance.balanceOf(deployerAccount)).to.be.a.bignumber.equal(totalSupply);
    });

    it("is not possible to send more token than aviable in total",async() =>{
        let instance= this.myTokenInstance;
          let balanceOfDeployer = await instance.balanceOf(deployerAccount);
          expect(instance.transfer(recipient,new BN(balanceOfDeployer+1) ) ).to.eventually.be.rejected;
          return expect(instance.balanceOf(deployerAccount)).to.eventually.be.a.bignumber.equal(balanceOfDeployer);
      });
   


    it("is possible to send tokens between accounts", async()=>{
        const sendToken=1;
        let instance= this.myTokenInstance;
        let totalSupply = await instance.totalSupply();
        expect(instance.balanceOf(deployerAccount)).to.eventually.be.a.bignumber.equal(totalSupply);
        expect(instance.transfer(recipient,sendToken)).to.eventually.be.fulfilled;
        expect(instance.balanceOf(deployerAccount)).to.eventually.be.a.bignumber.equal(totalSupply.sub(new BN(sendToken)));
        return expect(instance.balanceOf(recipient)).to.eventually.be.a.bignumber.equal(new BN(sendToken));
    });

})