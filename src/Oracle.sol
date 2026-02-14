// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./AMM.sol";

/// @notice Simple cumulative-price TWAP oracle (demo only)
contract Oracle {
    AMM public amm;

    struct Observation {
        uint256 timestamp;
        uint256 priceCumulative;
    }

    Observation[] public observations;
    uint256 public priceCumulative; // sum(price * dt)
    uint256 public lastTimestamp;

    constructor(AMM _amm) {
        amm = _amm;
        lastTimestamp = block.timestamp;
        priceCumulative = 0;
        observations.push(Observation({timestamp: lastTimestamp, priceCumulative: priceCumulative}));
    }

    function update() external {
        uint256 price = amm.priceXinY();
        uint256 dt = block.timestamp - lastTimestamp;
        if (dt > 0) {
            priceCumulative += price * dt;
            lastTimestamp = block.timestamp;
            observations.push(Observation({timestamp: lastTimestamp, priceCumulative: priceCumulative}));
        }
    }

    function spot() external view returns (uint256) {
        return amm.priceXinY();
    }

    /// @notice average price over the last `secondsAgo` seconds
    function consult(uint256 secondsAgo) external view returns (uint256) {
        require(observations.length > 1, "NO_OBS");
        uint256 targetTime = block.timestamp - secondsAgo;

        Observation memory newest = observations[observations.length - 1];
        Observation memory older = observations[0];

        // find latest observation at or before targetTime
        for (uint256 i = observations.length; i > 0; i--) {
            Observation memory obs = observations[i - 1];
            if (obs.timestamp <= targetTime) {
                older = obs;
                break;
            }
        }

        uint256 elapsed = newest.timestamp - older.timestamp;
        require(elapsed > 0, "ZERO_ELAPSED");
        return (newest.priceCumulative - older.priceCumulative) / elapsed;
    }
}
