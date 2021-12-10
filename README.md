# Automatic Gauge Votes incentives On Bribe.Crv.Finance

## Summary
The main contract is the BribesManager.sol contract. It has no admin controls.

On deployment of the contract, the user needs to input the following parameters:
 1. <italic>token</italic>: The address of the reward/incentive that will be used for bribing
 2. <italic>gauge</italic>: the address of the required curve gauge
 3. <italic>tokens_per_vote</italic>: the amount of tokens that will be sent to the curve bribing contract per vote(voting cycle).

 Anybody can send tokens to the contract to be used for bribing.
 Once sent the user has to call the <strong>sendBribe()</strong> function to send the tokens to the curve bribing contract. <strong>The sendBribe()</strong> method requires no parameters and can be called by anyone.

 The sendBribe() method can be called only once per voting cycle (vote). If called more than once then the method will revert with the message <strong>"Bribe already sent"</strong>. 

 The <strong>sendBribe()</strong> method will also revert if the contract doesn't have any tokens for bribing.

 If the contract has more than zero tokens but less than TOKEN_PER_VOTE tokens, then the <strong>sendBribe()</strong> method will send whatever tokens the contract has to the curve bribe contract.


## To Add
1. Add links to everything
2. Documentation of the code
3. Video demo
4. List of all the crvGauges (if time permits)
5. Installation & Setup
6. Gas costs


## Documentation
1. if there are more than zero but less than TOKEN_PER_VOTE tokens then whatever is left will be sent to the gauge voting cycle

## Gas 
At first, I created a single BribesManager contract with all the code in it. But the deployment cost was very high (342210 gas). So I changed it to a library-contract architecture where the <strogn>BribesLogic</strong> library contains all the logic and the <strong>BribesManager</strong> stores the state variables. This reduced the cost of deploying the BribesManager to 221089 gas (<strong>35.4 %</strong> reduction). To check the gas costs for yourself run the following command
```
brownie test tests/test_gas_costs.py -s --gas
```
<img src="https://user-images.githubusercontent.com/47485188/145599353-1e8b27fd-198c-4701-a05b-a40adc2ac3ea.png"> </img>