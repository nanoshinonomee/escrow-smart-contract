// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

import "./SafeMath.sol";

contract Escrow {
    
    using SafeMath for uint256; // this will add functionality to all uint256 variables
    
    // this is the only person who can withdraw and transfer amounts and deposit amounts into the smart contract
    address agent;
    
    mapping(address => uint256) public deposits;    // this is our array to match address to amount they own of a coin
    
    // we only want the escrow agent to be able to call these functions 
    modifier onlyAgent(){
        require(msg.sender == agent);   // compare caller address to agent 
        // throws an exception if its not true, hence the require
        _;  // what this does is it will run the function or code that is using this modifer in the place of the _; amazing
        // explanation can be explained here https://medium.com/coinmonks/the-curious-case-of-in-solidity-16d9eb4440f1
    }
    
    constructor () {
        // the constructor only runs once, when the contract is first deployed
        agent = msg.sender;// this will set the Agent variable (which is an address) to whoever deployed the smart contract, the msg.sender

    }
    

    function deposit(address payee) public onlyAgent payable{
        // the payee is the person who receieves the funds into a variable mapping
        // this function will be called to basically transfer funds from the person who called it to the person who is the payee
        
        // you need the payable functionality in order to call the msg.value parameter
        // the msg.value is the amount of eth sent with the tx
        uint256 amount = msg.value;
        
        deposits[payee] = deposits[payee].add(amount);  // adding the amount payed to the totals in the depsosit account
        // note that this does not actually move the funds into the address, just into a variable to temporarily hold it
        
        //notice the onlyAgent modifier

    }
    
    
    function withdraw(address payable payee) public onlyAgent {
        // this function moves the amounts found in the deposits mapping, into the actual account associated with the deposits mapping
        
        // notice the onlyAgent modifier
        
        uint256 payment = deposits[payee];
        deposits[payee] = 0;        // zero it out after storing the amount into the payment variable
        payee.transfer(payment);    // transfer the amount into the actual address of the payee

    }
    
    // TODO you might want to make it where a user can easily see the values in the Deposit Addresses, so you can check how much eth is in the account to be withdrawn
    
    
    
}
