# Automatic Gauge Votes incentives On Bribe.Crv.Finance

## Summary
### [BribesManager.sol]((https://github.com/realdiganta/crv-bribe-automator/blob/main/contracts/BribesManager.sol))
The main contract is the BribesManager.sol contract. It has no admin controls.

On deployment of the contract, the user needs to input the following parameters:
 1. <strong>token</strong>: The address of the reward/incentive that will be used for bribing
 2. <strong>gauge</strong>: the address of the required curve gauge
 3. <strong>tokens_per_vote</strong>: the amount of tokens that will be sent to the curve bribing contract per vote(voting cycle).

 Anybody can send tokens to the contract to be used for bribing.
 Once sent the user has to call the <strong>sendBribe()</strong> method to send the tokens to the curve bribing contract. <strong>The sendBribe()</strong> method requires no parameters and can be called by anyone.

 The <strong>sendBribe()</strong> method can be called only once per voting cycle (vote). If called more than once then the method will revert with the message <strong>"Bribe already sent"</strong>. 

 The <strong>sendBribe()</strong> method will also revert if the contract doesn't have any tokens for bribing.

 If the contract has more than zero tokens but less than TOKEN_PER_VOTE tokens, then the <strong>sendBribe()</strong> method will send whatever tokens the contract has to the curve bribe contract.

 ### [BribesLogic.sol]
 This is a library which contains all the logic for the BribesManager contract. This needs to by deployed just once.

 ## [BribesFactory.sol]
This is a factory contract added for ease of deployment of the BribesManager contract by any user. This also reduces the gas cost for deploying a BribesManager contract (details below under Gas Costs section). This Factory contract needs to be deployed just once.

The user has to call the <strong>deployManager()</strong> method with the required parameters to deploy a new BribesManager contract. A <strong>NewManager</strong> event is emitted on contract deployment to keep logs of all the managers deployed.

## To Add
1. Add links to everything
2. Documentation of the code
3. Video demo
4. List of all the crvGauges (if time permits)
5. Installation & Setup
6. Gas costs


## Gas Costs
At first, I created a single BribesManager contract with all the code in it. But the deployment cost was very high (342210 gas). So I changed it to a library-contract architecture where the <strogn>BribesLogic</strong> library contains all the logic and the <strong>BribesManager</strong> stores the state variables. This reduced the cost of deploying the BribesManager to 221089 gas (<strong>35.4 %</strong> reduction).
I also added another BribesFactory contract which can be used to deploy new BribesManager using the deployManager() method. This further reduces the gas cost of deploying a BribesManager contract to <strong>209707 gas</strong>.
 To check the gas costs for yourself run the following command
```
brownie test tests/test_gas_costs.py -s --gas
```
<img src="https://user-images.githubusercontent.com/47485188/145610075-5dd17449-8e57-4552-bbb9-6f8ed5ab971c.png"> </img>