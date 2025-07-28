// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {VulnerablePiggyBank} from "../src/VulnerablePiggyBank.sol";
import {PiggyBankAttacker} from "../src/PiggyBankAttacker.sol";

contract PiggyBankAttackerTest is Test {
    VulnerablePiggyBank public piggyBank;
    PiggyBankAttacker public attacker;
    address public owner;
    address public attackerAddress;

    function setUp() public {
        // Setup accounts
        owner = makeAddr("owner");
        attackerAddress = makeAddr("attacker");
        
        // Deploy contracts
        vm.prank(owner);
        piggyBank = new VulnerablePiggyBank();
        
        vm.prank(attackerAddress);
        attacker = new PiggyBankAttacker(address(piggyBank));

        // Fund the piggy bank
        vm.deal(owner, 10 ether);
        vm.prank(owner);
        piggyBank.deposit{value: 5 ether}();
    }

    function testAttackSuccess() public {
        // Initial state checks
        assertEq(address(piggyBank).balance, 5 ether);
        
        // Prepare attacker
        vm.deal(attackerAddress, 1 ether);
        
        // Perform attack
        vm.prank(attackerAddress);
        attacker.attack{value: 1 ether}();

        // Verify attack results
        assertEq(address(piggyBank).balance, 0);
        assertEq(address(attacker).balance, 6 ether);
    }

    function testAttackFailsWithZeroValue() public {
        vm.prank(attackerAddress);
        vm.expectRevert("Need ETH to attack");
        attacker.attack{value: 0}();
    }

    receive() external payable {}
}
