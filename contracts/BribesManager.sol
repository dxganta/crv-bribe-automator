// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "../interfaces/curve/IBribeV2.sol";
import "../interfaces/token/IERC20.sol";

// TODO:
// turn this into a library and use a proxy contract & check where the gas costs is less
// organise the storage variables to use storage more efficiently

contract BribesManager {
    address public immutable TOKEN;
    address public immutable GAUGE;
    uint public immutable TOKENS_PER_VOTE;
    uint public lastPeriod;

    address constant CURVE_BRIBE = 0x7893bbb46613d7a4FbcC31Dab4C9b823FfeE1026;
    uint constant WEEK = 86400 * 7;

    /// @param token Address of the reward/incentive token
    /// @param gauge address of the curve gauge
    /// @param tokens_per_vote number of tokens to add as incentives per vote
    constructor(address token, address gauge, uint tokens_per_vote) {
        TOKEN = token;
        GAUGE = gauge;
        TOKENS_PER_VOTE = tokens_per_vote;

        IERC20(TOKEN).approve(CURVE_BRIBE, type(uint).max);
    }

    /// @dev sends the token incentives to curve gauge votes for the next vote cycle/period
    function sendBribe() public {
        // require(lastPeriod != 0, "Not initialized");
        uint balance = IERC20(TOKEN).balanceOf(address(this));
        uint amount = TOKENS_PER_VOTE;
        require(balance > 0, "No tokens");

        if (amount > balance) {
            amount = balance;
        }

        // make sure that the token incentives can be sent only once per vote 
        require (block.timestamp > lastPeriod + 604800, "Bribe already sent"); // 604800 seconds in 1 week

        IBribeV2(CURVE_BRIBE).add_reward_amount(GAUGE, TOKEN, amount);
        lastPeriod = IBribeV2(CURVE_BRIBE).active_period(GAUGE, TOKEN);
    }

    /// @dev returns the remaining number of votig cycles that the contract can vote for with current token balance
    function votesLeft() public view returns (uint) {
        return IERC20(TOKEN).balanceOf(address(this)) / TOKENS_PER_VOTE;
    }
}