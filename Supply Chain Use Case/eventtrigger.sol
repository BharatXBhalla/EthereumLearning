// SPDX-License-Identifier: MIT
pragma solidity ^0.7.4;

contract Ownerable{
    address public owner;
    constructor(){
        owner=msg.sender;
    }
    modifier onlyOwner(){
        require(msg.sender == owner , "You are not Owner");
        _;
    }
    function isOwner() public view returns(bool){
        return(msg.sender == owner);
    }
}
contract Item{
     uint public priceInWei;
     uint public pricePaid;
     uint public index;
     
     ItemManager parentContract;
     
     constructor(ItemManager _parentContract,uint _priceInWei,uint _index) {
         priceInWei=_priceInWei;
         index=_index;
         parentContract=_parentContract;
     }
     
     receive () external payable{
         require(pricePaid == 0, "Item is paid already");
         require(priceInWei == msg.value , "Only full payments allowed");
         pricePaid +=msg.value;
         (bool success, )=address(parentContract).call{value:msg.value}(abi.encodeWithSignature("triggerPayment(uint256)",index));
         require(success,"The Transaction was'nt successful, canceling");
     }
}

contract ItemManager is Ownerable{

    enum SuppyChainState{Created,Paid,Delivered}
    
    struct S_Item{
        string _identifier;
        uint _itemPrice;
        ItemManager.SuppyChainState _state;
        Item _item;
    }
    
    mapping(uint => S_Item) public items;
    uint itemIndex;
    
    event SuppyChainStep(uint _itemIndex, uint _step,address _itemaddress);
    
    function createItem(string memory _identifier,uint _itemPrice) public onlyOwner{
        
        Item item=new Item(this,_itemPrice,itemIndex);
        items[itemIndex]._identifier=_identifier;
        items[itemIndex]._itemPrice=_itemPrice;
        items[itemIndex]._state=ItemManager.SuppyChainState.Created;
        items[itemIndex]._item=item;
        emit SuppyChainStep(itemIndex, uint(items[itemIndex]._state),address(item));
        
        itemIndex++;
    }
    function triggerPayment(uint _itemIndex) public payable{
        require(items[_itemIndex]._itemPrice == msg.value , "Only Full Payments Accepted");
        require(items[_itemIndex]._state == SuppyChainState.Created , "Item is Further in the chain");
        items[_itemIndex]._state =SuppyChainState.Paid;
        emit SuppyChainStep(_itemIndex, uint(items[_itemIndex]._state),address(items[_itemIndex]._item));
    }
    function triggerDelivery(uint _itemIndex) public onlyOwner{
        require(items[_itemIndex]._state == SuppyChainState.Paid, "Not Paid ");
        items[_itemIndex]._state =SuppyChainState.Delivered;
        emit SuppyChainStep(_itemIndex, uint(items[_itemIndex]._state),address(items[_itemIndex]._item));
        
    }
}