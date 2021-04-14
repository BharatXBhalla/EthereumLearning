// SPDX-License-Identifier: MIT
pragma solidity ^0.7.4;

import "./Items.sol";
import "./Ownerable.sol";

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