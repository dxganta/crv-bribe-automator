// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "../interfaces/curve/IBribeV2.sol";
import "../interfaces/token/IERC20.sol";

contract BribesManager {
    address public constant CURVE_BRIBE = 0x7893bbb46613d7a4FbcC31Dab4C9b823FfeE1026;
    address public immutable TOKEN;
    address public immutable GAUGE;
    uint public immutable TOKEN_PER_VOTE;
    uint private lastBribe;

    constructor(address token, address gauge, uint token_per_vote) {
        TOKEN = token;
        GAUGE = gauge;
        TOKEN_PER_VOTE = token_per_vote;
    }

    /// @dev sends the token incentives to curve gauge votes for the next vote cycle/period
    function initiateBribe() public {
        // make sure that the token incentives can be sent only once per vote 
        uint activePeriod = IBribeV2(CURVE_BRIBE).active_period(GAUGE, TOKEN);
        require (activePeriod != lastBribe, "Incentives already sent");
        lastBribe = activePeriod;

        uint balance = IERC20(TOKEN).balanceOf(address(this));
        uint amount = TOKEN_PER_VOTE;
        require(balance > 0, "No tokens");

        if (TOKEN_PER_VOTE > balance) {
            amount = balance;
        }

        IBribeV2(CURVE_BRIBE).add_reward_amount(GAUGE, TOKEN, amount);
    }
}