import brownie
from brownie import (
    accounts,
    interface
)
from config import (
    GAUGE,
    TOKEN,
    TOKENS_PER_VOTE
)

# TESTS
# 1. able to send tokens to the contract
# 2. able to send tokens from the contract to the bribe gauge
# 3. must be able to add tokens to a voting cycle only once, (also test that once the current voting cycle is over, we are able to add rewards for the next voting cycle)
# 4. initiateBribe must fail if token balance is zero
# 5. if token balance > 0 but less than TOKEN_PER_VOTE, then the remaining tokens must go to the vote


def test_main(bribesManager, token_whale):
    user1 = accounts[2]
    user2 = accounts[5]
    token = interface.IERC20(TOKEN)

    # # bribing must fail since the contract has zero tokens
    # assert token.balanceOf(bribesManager) == 0
    # with brownie.reverts("No tokens"):
    #     bribesManager.sendBribe({"from": user1})

    # # send tokens to the contract for 3 voting cycles
    # token.transfer(bribesManager, TOKENS_PER_VOTE * 3, {"from": token_whale})
