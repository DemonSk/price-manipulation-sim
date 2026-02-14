// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./Oracle.sol";

/// @notice Lending market using TWAP oracle + circuit breaker (demo mitigation)
contract LendingSafe {
    Oracle public oracle;
    mapping(address => uint256) public collateralX;
    mapping(address => uint256) public debtY;

    uint256 public constant LTV = 50; // 50%
    uint256 public constant MAX_JUMP = 20; // max 20% price jump per update
    uint256 public constant TWAP_WINDOW = 5 minutes;
    uint256 public lastPrice;

    constructor(Oracle _oracle) {
        oracle = _oracle;
        lastPrice = oracle.spot();
    }

    function depositX(uint256 x) external {
        collateralX[msg.sender] += x;
    }

    function borrowY(uint256 y) external {
        uint256 price = oracle.consult(TWAP_WINDOW);
        // circuit breaker
        uint256 diff = price > lastPrice ? price - lastPrice : lastPrice - price;
        require((diff * 100) / lastPrice <= MAX_JUMP, "price jump");

        uint256 collateralValueY = (collateralX[msg.sender] * price) / 1e18;
        uint256 maxBorrow = (collateralValueY * LTV) / 100;
        require(debtY[msg.sender] + y <= maxBorrow, "exceeds LTV");
        debtY[msg.sender] += y;

        lastPrice = price;
    }
}
