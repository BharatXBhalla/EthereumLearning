// SPDX-License-Identifier: MIT
pragma solidity ^0.7.4;

contract Item{
     uint public priceInWei;
     uint public pricePaid;
     uint public index;
     
     ItemManager parentContract;
     
     constructor(ItemManager _parentContract,uint _priceInWei,uint _index){
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

contract ItemManager{

    enum SuppyChainState{Created,Paid,Delivered}
    
    struct S_Item{
        string _identifier;
        uint _itemPrice;
        ItemManager.SuppyChainState _state;
        Item item;
    }
    
    mapping(uint => S_Item) public items;
    uint itemIndex;
    
    event SuppyChainStep(uint _itemIndex, uint _step);
    
    function createItem(string memory _identifier,uint _itemPrice) public{
        
        items[itemIndex]._identifier=_identifier;
        items[itemIndex]._itemPrice=_itemPrice;
        items[itemIndex]._state=ItemManager.SuppyChainState.Created;
        
        emit SuppyChainStep(itemIndex, uint(items[itemIndex]._state));
        
        itemIndex++;
    }
    function triggerPayment(uint _itemIndex) public payable{
        require(items[_itemIndex]._itemPrice == msg.value , "Only Full Payments Accepted");
        require(items[_itemIndex]._state == SuppyChainState.Created , "Item is Further in the chain");
        items[_itemIndex]._state =SuppyChainState.Paid;
        emit SuppyChainStep(itemIndex, uint(items[itemIndex]._state));
    }
    function triggerDelivery(uint _itemIndex) public{
        require(items[_itemIndex]._state == SuppyChainState.Paid, "Not Paid ");
        items[_itemIndex]._state =SuppyChainState.Delivered;
        emit SuppyChainStep(itemIndex, uint(items[itemIndex]._state));
        
    }
}