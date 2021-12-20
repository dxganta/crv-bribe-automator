from brownie import (
    accounts,
    interface,
    BribesManager,
    BribesLogic,
    BribesFactory
)
from config import (
    GAUGE,
    TOKENS_PER_VOTE
)

TOKEN = "0x4e15361fd6b4bb609fa63c81a2be19d873717870"


def test_gas_costs():
    token_whale = accounts.at(
        "0x57900b3dc6206994d3b2d593db8f6c6bfdbb61a9", force=True)
    dust = TOKENS_PER_VOTE * 0.4
    token = interface.IERC20(TOKEN)

    # deply the BribesLogic library first
    BribesLogic.deploy({"from": token_whale})

    # this will show the gas costs of directly deploying the BribesManager contract
    manager = BribesManager.deploy(
        TOKEN, GAUGE, TOKENS_PER_VOTE,  {"from": token_whale})

    # send tokens for bribing
    token.transfer(manager, TOKENS_PER_VOTE * 2 + dust, {'from': token_whale})

    # bribe
    manager.sendBribe()

    # factory
    factory = BribesFactory.deploy({"from": token_whale})
    # this will show the gas cost of deploying the BribesManager contract using the factory contract
    manager_f = factory.deployManager(
        TOKEN, GAUGE, TOKENS_PER_VOTE, {"from": token_whale})
