# Automatic Gauge Votes Incentives On Bribe.Crv.Finance
## Summary
### [BribesManager.sol](https://github.com/realdiganta/crv-bribe-automator/blob/main/contracts/BribesManager.sol)
The main contract is the BribesManager.sol contract. It has no admin controls.

On deployment of the contract, the user needs to input the following parameters:
 1. <strong>token (address)</strong>: The contract address of the reward/incentive (ERC20 Token) that will be used for bribing.
 2. <strong>gauge (address)</strong>: The contract address of the required curve gauge.
 3. <strong>tokensPerVote (uint)</strong>: The number of tokens that will be sent to the curve bribing contract per vote (voting cycle).

 Anybody can send tokens to the contract to be used for bribing.
 Once sent the user has to call the <strong>sendBribe()</strong> method to send the tokens to the curve bribing contract. <strong>The sendBribe()</strong> method requires no parameters and can be called by anyone.

 The <strong>sendBribe()</strong> method can be called only once per voting cycle (vote). If called more than once then the method will revert with the message <strong>"Bribe already sent"</strong>. 

 The <strong>sendBribe()</strong> method will also revert if the contract doesn't have any tokens for bribing.

 If the contract has more than zero tokens but less than TOKEN_PER_VOTE tokens, then the <strong>sendBribe()</strong> method will send whatever tokens the contract has to the curve bribe contract.

 ### [BribesLogic.sol](https://github.com/realdiganta/crv-bribe-automator/blob/main/contracts/library/BribesLogic.sol)
 This is a library which contains all the logic for the BribesManager contract. This needs to by deployed just once.

 ### [BribesFactory.sol](https://github.com/realdiganta/crv-bribe-automator/blob/main/contracts/BribesFactory.sol)
This is a factory contract added for ease of deployment of the BribesManager contract by any user. This also reduces the gas cost for deploying a BribesManager contract (details below under Gas Costs section). This Factory contract needs to be deployed just once.

The user has to call the <strong>deployManager()</strong> method with the required parameters to deploy a new BribesManager contract. A <strong>NewManager</strong> event is emitted on contract deployment to keep logs of all the managers deployed.
## Installation & Setup

1. Install [Brownie](https://eth-brownie.readthedocs.io/en/stable/install.html) & [Ganache-CLI](https://www.npmjs.com/package/ganache-cli), if you haven't already.

2. Copy the .env.example file, and rename it to .env

3. Sign up for Infura and generate an API key. Store it in the WEB3_INFURA_PROJECT_ID environment variable.

4. Sign up for Etherscan and generate an API key. This is required for fetching source codes of the ethereum mainnet contracts we will be interacting with. Store the API key in the ETHERSCAN_TOKEN environment variable.

Install the dependencies in the package
```
## Python Dependencies
pip install -r requirements.txt
```

## Tests
All required tests for the contract are included in the [tests/test_main.py](https://github.com/realdiganta/crv-bribe-automator/blob/main/tests/test_main.py) file. To run the tests run the following command
```
brownie test tests/test_main.py
```
<img src="https://user-images.githubusercontent.com/47485188/146816035-c3371b6b-8d79-420f-84cc-7b17ef7fde16.png"> </img>

## Gas Costs
At first, I created a single BribesManager contract with all the code in it. But the deployment cost was very high (342210 gas). So I changed it to a library-contract architecture where the <strong>[BribesLogic](https://github.com/realdiganta/crv-bribe-automator/blob/main/contracts/library/BribesLogic.sol)</strong> library contains all the logic and the <strong>[BribesManager](https://github.com/realdiganta/crv-bribe-automator/blob/main/contracts/BribesManager.sol)</strong> stores the state variables. This reduced the cost of deploying the BribesManager to 202742 gas (<strong>27.5 %</strong> reduction).
I further added another <strong>[BribesFactory]((https://github.com/realdiganta/crv-bribe-automator/blob/main/contracts/BribesFactory.sol)) </strong>contract which can be used to deploy new BribesManager using the deployManager() method. This further reduces the gas cost of deploying a BribesManager contract to <strong>193647 gas</strong>.

To check the gas costs for yourself run the following command
```
brownie test tests/test_gas_costs.py -s --gas
```
<img src="https://user-images.githubusercontent.com/47485188/146815523-2919c6ec-701a-4153-afee-24cdd34af386.png"> </img>

## Deployed Addresses (Ropsten Testnet)
1. BribesLogic Library : [0xcbCE8453adcD7a19E3087607D98A939F9b1738ba](https://ropsten.etherscan.io/address/0xcbCE8453adcD7a19E3087607D98A939F9b1738ba)
2. BribesFactory Contract : [0x4cCAA98F5b718deEDc003140738Bd1E38a60c342](https://ropsten.etherscan.io/address/0x4ccaa98f5b718deedc003140738bd1e38a60c342)
3. BribesManager Contract : [0xfDdA22A5Ef8cdbd12341f871EbDA4eE588A41E33](https://ropsten.etherscan.io/address/0xfDdA22A5Ef8cdbd12341f871EbDA4eE588A41E33)

## Notes
Importance has been given here on reducing gas costs as compared to accessiblity. For example, in the BribesManager contract you may see that I have made the storage variables private (TOKEN, GAUGE, TOKENS_PER_VOTE). This was done to reduce gas costs. One might ask that when sending bribes a user might want to know about the token address, gauge address, tokens per vote etc. of the BribesManager contract. But as you can see on contract deployment of the BribesManager using the deployManager() method in the BribesFactory contract, an NewManager() event is emitted. So for the UI we can easily get the details of any BribesManager contract by querying that NewManager() event.

For any queries please ping me on discord diganta.eth#0692 or mail at digantakalita.ai@gmail.com