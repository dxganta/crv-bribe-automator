# Automatic Gauge Votes incentives On Bribe.Crv.Finance


## To Add
1. Add links to everything
2. Documentation of the code
3. Video demo
4. List of all the crvGauges (if time permits)
5. Installation & Setup
6. Gas costs


## Documentation
1. if there are more than zero but less than TOKEN_PER_VOTE tokens then whatever is left will be sent to the gauge voting cycle

2. The contract needs to be initialized first otherwise the sendBribe won't run

## Gas 
At first, I created a single BribesManager contract with all the code in it. But the deployment cost was very high (342210 gas). So I changed it to a library-contract architecture where the library contains all the logic and the BribesManager stores the state variables. This reduced the cost of deploying the BribesManager to 221089 gas (35.4 % reduction). To check the gas costs for yourself run the following command
```
    brownie test tests/test_gas_costs.py -s --gas
```
<img src="https://user-images.githubusercontent.com/47485188/145599353-1e8b27fd-198c-4701-a05b-a40adc2ac3ea.png"> </img>