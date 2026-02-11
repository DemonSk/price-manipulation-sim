// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @notice Toy constant‑product AMM (not production‑safe). For demo only.
contract AMM {
    uint256 public reserveX;
    uint256 public reserveY;

    constructor(uint256 x, uint256 y) {
        reserveX = x;
        reserveY = y;
    }

    function priceXinY() external view returns (uint256) {
        return (reserveY * 1e18) / reserveX;
    }

    function swapXforY(uint256 xIn) external returns (uint256 yOut) {
        // xIn * yOut = k delta (no fee)
        uint256 k = reserveX * reserveY;
        reserveX += xIn;
        uint256 newY = k / reserveX;
        yOut = reserveY - newY;
        reserveY = newY;
    }

    function swapYforX(uint256 yIn) external returns (uint256 xOut) {
        uint256 k = reserveX * reserveY;
        reserveY += yIn;
        uint256 newX = k / reserveY;
        xOut = reserveX - newX;
        reserveX = newX;
    }
}
