import React, { Component } from "react";
import TokenContract from "./contracts/MyToken.json";
import TokenSaleContract from "./contracts/MyTokenSale.json";
import KycContract from "./contracts/Kyc.json";
import getWeb3 from "./getWeb3";

import "./App.css";

class App extends Component {
  state = { loaded:false , kycaddress :"0x",tokenSalesContractAddress:"0x"};

  componentDidMount = async () => {
    try {
      // Get network provider and web3 instance.
     this.web3 = await getWeb3();

      // Use web3 to get the user's accounts.
     this.accounts = await this.web3.eth.getAccounts();

      // Get the contract instance.
     this.networkId = await this.web3.eth.net.getId();
    
     this.Tokeninstance = new this.web3.eth.Contract(
        TokenContract.abi,
        TokenContract.networks[this.networkId] && TokenContract.networks[this.networkId].address,
      );

      this.TokenSaleinstance = new this.web3.eth.Contract(
        TokenSaleContract.abi,
        TokenSaleContract.networks[this.networkId] && TokenContract.networks[this.networkId].address
      );

      this.Kycinstance = new this.web3.eth.Contract(
        KycContract.abi,
        KycContract.networks[this.networkId] && KycContract.networks[this.networkId].address
      )

      // Set web3, accounts, and contract to the state, and then proceed with an
      // example of interacting with the contract's methods.
      console.log("Loaded"+this.state.loaded)
      this.setState({loaded:true,tokenSalesContractAddress:TokenSaleContract.networks[this.networkId].address},this.render);
    } catch (error) {
      // Catch any errors for any of the above operations.
      alert(
        `Failed to load web3, accounts, or contract. Check console for details.`,
      );
      console.error(error);
    }
  };

  handleInputChange = (event) =>{
    const target= event.target;
    const value = target.type === "checkbox" ? target.checkbox : target.value;
    const name=target.name;
    this.setState({
      [name]:value
    });
  }

  handleKycRequest= async () =>{
    await this.Kycinstance.methods.setKycCompleted(this.state.kycaddress).send({from:this.accounts[0]});
    alert("KYC for "+ this.state.kycaddress+ " is completed");
  }

  render() {

    if (!this.state.loaded) {
      return <div>Loading Web3, accounts, and contract...</div>;
    }
    return (
      <div className="App">
        <h1>KYC for CPD Token</h1>
        <p>This Token will bring change ! Purchase soon !</p>
        <input type="text" name="kycaddress" value={this.state.kycaddress} onChange={this.handleInputChange}/>
        <button type="button" onClick={this.handleKycRequest} >KYC Above Addrr</button>
        <br></br>
        <h1>BUY CPD Token </h1>
        <p>Transfer Funds to {this.state.tokenSalesContractAddress}</p>
      </div>
    );
  }
}

export default App;
