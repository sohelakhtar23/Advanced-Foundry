// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {MyToken} from "../src/MyToken.sol";
import {DeployMyToken} from "../script/DeployMyToken.s.sol";

contract TestMyToken is Test {
    address bob = makeAddr("Bob");
    address alice = makeAddr("Alice");
    uint256 STARTING_BALANCE = 50 ether;

    MyToken myToken;
    DeployMyToken deployer;

    function setUp() public {
        deployer = new DeployMyToken();
        myToken = deployer.run();

        vm.prank(msg.sender);
        myToken.transfer(bob, STARTING_BALANCE);
    }

    function testBobBalance() public {
        assert(myToken.balanceOf(bob) == STARTING_BALANCE);
    }

    function testAllowances() public {
        uint256 initialAllowance = 10 ether;
        // Bob approves Alice to spend 10 tokens on his behalf
        vm.prank(bob);
        myToken.approve(alice, initialAllowance);

        uint256 transferAmount = 5 ether;

        vm.prank(alice);
        myToken.transferFrom(bob, alice, transferAmount);

        // Check Alice's balance after transfer
        assert(myToken.balanceOf(alice) == transferAmount);
        // Check Bob's balance after transfer
        assert(myToken.balanceOf(bob) == (STARTING_BALANCE - transferAmount));
    }

    function testTransferFailsIfNotEnoughBalance() public {
        vm.prank(alice);
        vm.expectRevert(); // ERC20: transfer amount exceeds balance
        myToken.transfer(bob, 1 ether);
    }

    function testTransferFromFailsIfAllowanceTooLow() public {
        vm.prank(bob);
        myToken.approve(alice, 2 ether);

        vm.prank(alice);
        vm.expectRevert(); // ERC20: insufficient allowance
        myToken.transferFrom(bob, alice, 5 ether);
    }

    function testMultipleTransfers() public {
        vm.prank(msg.sender);
        myToken.transfer(bob, 20 ether);

        vm.prank(bob);
        myToken.transfer(alice, 10 ether);

        assert(myToken.balanceOf(alice) == 10 ether);
        assert(myToken.balanceOf(bob) == 60 ether);
    }
}