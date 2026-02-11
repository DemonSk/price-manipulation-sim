// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./AMM.sol";

/// @notice Toy lending market using AMM spot price as oracle (vulnerable by design).
contract Lending {
    AMM public amm;
    mapping(address => uint256) public collateralX;
    mapping(address => uint256) public debtY;

    uint256 public constant LTV = 50; // 50%

    constructor(AMM _amm) {
        amm = _amm;
    }

    function depositX(uint256 x) external {
        collateralX[msg.sender] += x;
    }

    function borrowY(uint256 y) external {
        uint256 price = amm.priceXinY();
        uint256 collateralValueY = (collateralX[msg.sender] * price) / 1e18;
        uint256 maxBorrow = (collateralValueY * LTV) / 100;
        require(debtY[msg.sender] + y <= maxBorrow, "exceeds LTV");
        debtY[msg.sender] += y;
    }
}
