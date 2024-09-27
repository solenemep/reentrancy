// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "lib/forge-std/src/Test.sol";

import "src/Lottery.sol";
import "src/Attacker.sol";

contract AttackerTest is Test {
    Lottery public lottery;
    Attacker public attacker;

    address public owner;

    uint256 deployAmount = 0.5 ether;
    uint256 playAmount = 0.1 ether;
    uint256 rewardAmount = 0.2 ether;

    function setUp() public {
        vm.createSelectFork(vm.envString("SEPOLIA_RPC_URL"), 6770142);
        owner = vm.addr(vm.envUint("PRIVATE_KEY"));

        assertGt(owner.balance, deployAmount);
        vm.prank(owner);
        lottery = new Lottery{value: deployAmount}();

        uint256 winAmount = uint256(
            vm.load(address(lottery), bytes32(uint256(0)))
        );

        assertGt(owner.balance, playAmount);
        vm.prank(owner);
        attacker = new Attacker{value: playAmount}(address(lottery), winAmount);

        assertEq(address(lottery).balance, deployAmount);
        assertEq(address(attacker).balance, playAmount);
        assertEq(lottery.hackCompleted(), false);
    }

    function test_attack() public {
        uint256 balanceLBefore = address(lottery).balance;
        uint256 balanceABefore = address(attacker).balance;

        assertEq(balanceLBefore, deployAmount);
        assertEq(balanceABefore, playAmount);
        assertEq(lottery.hackCompleted(), false);

        attacker.attack();

        uint256 balanceLAfter = address(lottery).balance;
        uint256 balanceAAfter = address(attacker).balance;

        assertEq(balanceLAfter, 0);
        assertEq(balanceAAfter, playAmount + (rewardAmount - playAmount) * 5);
        assertEq(lottery.hackCompleted(), true);
    }

    function test_withdraw() public {
        uint256 balanceABefore = address(attacker).balance;
        uint256 balanceUBefore = owner.balance;

        vm.expectRevert(NotAllowed.selector);
        attacker.withdraw();
        vm.stopPrank();

        assertEq(address(attacker).balance, balanceABefore);
        assertEq(owner.balance, balanceUBefore);

        vm.prank(owner);
        attacker.withdraw();

        uint256 balanceAAfter = address(attacker).balance;
        uint256 balanceUAfter = owner.balance;

        assertEq(balanceABefore - balanceAAfter, balanceABefore);
        assertEq(balanceUAfter - balanceUBefore, balanceABefore);
    }
}
