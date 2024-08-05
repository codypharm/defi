// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

/**
 * @title OracleLib
 * @author Chukwunonso Ikeji
 * @notice This library is used to check the chainlink Oracle for stale data.
 * If a price is stale , function will revert and render the DSCEngine unusable -  this is by design.
 * We want the dsc endigne to freezw if pricesa become stale.
 */
library OracleLib {
    uint256 private constant TIMEOUT = 3 hours;

    error ORACLELIB__STALEPRICE();

    function staleCheckLatestRoundData(AggregatorV3Interface priceFeed)
        public
        view
        returns (uint80, int256, uint256, uint256, uint80)
    {
        (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound) =
            priceFeed.latestRoundData();
        uint256 secondsSince = block.timestamp - updatedAt;
        if (secondsSince > TIMEOUT) {
            revert ORACLELIB__STALEPRICE();
        }
        return (roundId, answer, startedAt, updatedAt, answeredInRound);
    }
}
