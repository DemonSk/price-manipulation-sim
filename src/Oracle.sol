// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./AMM.sol";

/// @notice Naive spot oracle + simple TWAP accumulator (demo only)
contract Oracle {
    AMM public amm;
    uint256 public lastPrice;
    uint256 public lastTimestamp;
    uint256 public twap; // simple avg

    constructor(AMM _amm) {
        amm = _amm;
        lastPrice = amm.priceXinY();
        lastTimestamp = block.timestamp;
        twap = lastPrice;
    }

    function update() external {
        uint256 price = amm.priceXinY();
        uint256 dt = block.timestamp - lastTimestamp;
        if (dt > 0) {
            // naive TWAP: average of last and current
            twap = (twap + price) / 2;
            lastPrice = price;
            lastTimestamp = block.timestamp;
        }
    }

    function spot() external view returns (uint256) {
        return amm.priceXinY();
    }
}
