from brownie import (
    accounts,
    interface,
    BribesManager
)
from config import (
    GAUGE,
    TOKEN,
    TOKENS_PER_VOTE
)
import pytest


@pytest.fixture
def bribesManager(token_whale):
    """
        Deploys the BribesManager contract
    """
    token = interface.IERC20(TOKEN)
    deployer = token_whale

    manager = BribesManager.deploy(
        TOKEN, GAUGE, TOKENS_PER_VOTE,  {"from": deployer})

    token.approve(manager, TOKENS_PER_VOTE*3, {"from": deployer})
    manager.initialize(TOKENS_PER_VOTE * 3, {"from": deployer})

    return manager


@pytest.fixture
def token_whale():
    return accounts.at("0x090185f2135308bad17527004364ebcc2d37e5f6", force=True)
