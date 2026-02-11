// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/AMM.sol";
import "../src/Oracle.sol";
import "../src/LendingSafe.sol";

contract ManipulationSafeTest is Test {
    AMM amm;
    Oracle oracle;
    LendingSafe lend;

    function setUp() public {
        amm = new AMM(1_000e18, 1_000e18);
        oracle = new Oracle(amm);
        lend = new LendingSafe(oracle);
    }

    function test_manipulationBlockedByTwapAndBreaker() public {
        lend.depositX(10e18);

        // attacker tries to pump price
        amm.swapYforX(900e18);

        // move time forward and update oracle (twap moves partially)
        vm.warp(block.timestamp + 60);
        oracle.update();

        vm.expectRevert("price jump");
        lend.borrowY(15e18);
    }
}
