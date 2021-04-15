
const ItemManager = artifacts.require("./ItemManager.sol");

contract("Item Manager ",accounts =>{

    it("..should be able to add Item ", async function(){
        const ItemManagerInstance = await ItemManager.deployed();
        const itemName="test1";
        const itemPrice=500;

        const result = await ItemManagerInstance.createItem(itemName,itemPrice,{from : accounts[0]});

        assert.equal(result.logs[0].args._itemIndex,0,"It's not First Item");

        const item = await ItemManagerInstance.items(0);
        assert.equal(item._identifier,itemName, "The Identifier was different");
        


    })

});