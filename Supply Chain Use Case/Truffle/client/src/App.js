import React, { Component } from "react";
import ItemMangerContract from "./contracts/ItemManager.json";
import ItemContract from "./contracts/Item.json";
import getWeb3 from "./getWeb3";

import "./App.css";

class App extends Component {
  state = { loaded: false , cost :0,itemName:"example 1" };

  componentDidMount = async () => {
    try {
      // Get network provider and web3 instance.
       this.web3 = await getWeb3();

      // Use web3 to get the user's accounts.
      this.accounts = await this.web3.eth.getAccounts();

      // Get the contract instance.
      this.networkId = await this.web3.eth.net.getId();
      this.itemManger = new this.web3.eth.Contract(
        ItemMangerContract.abi,
        ItemMangerContract.networks[this.networkId] && ItemMangerContract.networks[this.networkId].address,
      );

      this.item =  new this.web3.eth.Contract(
        ItemContract.abi,
        ItemContract.networks[this.networkId] && ItemContract.networks[this.networkId].address,
      );

      // Set web3, accounts, and contract to the state, and then proceed with an
      // example of interacting with the contract's methods.
      this.setState({loaded: true});
      this.listenOnPayment();
    } catch (error) {
      // Catch any errors for any of the above operations.
      alert(
        `Failed to load web3, accounts, or contract. Check console for details.`,
      );
      console.error(error);
    }
  };

  listenOnPayment() {
    this.itemManger.events.SuppyChainStep().on("data", async function(evt){
      console.log(evt); 

      // based on Evt We can Perform some Actions 
    });
  }

  handleInputChange = (event) =>{
    const target= event.target;
    const value = target.type === "checkbox" ? target.checkbox : target.value;
    const name=target.name;
    this.setState({
      [name]:value
    });
  }
  handleSubmit = async () =>{
    const {cost,itemName} =this.state;
    let results=await this.itemManger.methods.createItem(itemName,cost).send({from: this.accounts[0]});
    console.log(results);
    alert("Send "+cost+ " Wei to " + results.events.SuppyChainStep.returnValues._itemaddress);
  }

  render() {
    if (!this.state.loaded) {
      return <div>Loading Web3, accounts, and contract...</div>;
    }
    return (
      <div className="App">
        <h1>Supplu Chain Example</h1>
        <p>Items</p>
        <h2>Add Item</h2>
        Cost in Wei : <input type="text" name="cost" value={this.state.cost} onChange={this.handleInputChange}/>
        Item Identifier : <input type="text" name="itemName" value={this.state.itemName} onChange={this.handleInputChange} />
        <button type="button" onClick={this.handleSubmit}>Add Item</button>

      </div>
    );
  }
}

export default App;
