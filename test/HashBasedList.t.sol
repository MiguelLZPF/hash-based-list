// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { Test, console } from "forge-std/Test.sol";
import { Deployment, DeploymentStoreInfo } from "@script/Configuration.s.sol";
import { HBLExample as HashBasedList } from "@src/HBLExample.sol";
import { HBLScript, DeployCommand } from "@script/HashBasedList.s.sol";

contract HBLTest is Test {
  // Constants
  address private constant DEFAULT_USER = address(10);
  uint256 private constant DEFAULT_USER_BALANCE = 100 ether;
  bytes32 private constant EMPTY_BYTES32 = bytes32(0);
  bytes32 private constant DEFAULT_NAMESPACE = bytes32("ThisIsANamespace");
  bytes32 private constant DEFAULT_ID = bytes32("ThisIsAnId");
  // Variables
  HashBasedList public hashBasedList;
  address admin = DEFAULT_SENDER;
  address payable user = payable(DEFAULT_USER);

  function setUp() public {
    Deployment memory deployment;
    // Transfer some ether to user
    vm.deal(user, DEFAULT_USER_BALANCE);
    // Deploy the contract
    (hashBasedList, deployment) = new HBLScript().deploy(
      DeployCommand({ storeInfo: DeploymentStoreInfo({ store: false, tag: bytes32(0) }) })
    );
    // Check the initial state
    assertEq(hashBasedList.getHblLength(EMPTY_BYTES32), 0);
  }

  function test_should_addHbl() public {
    //* 🗂️ Arrange ⬇
    vm.startPrank(user);
    // Initial state check
    assertEq(hashBasedList.getHblLength(DEFAULT_NAMESPACE), 0);
    //* 🎬 Act ⬇
    hashBasedList.addHbl(DEFAULT_NAMESPACE, DEFAULT_ID);
    //* ☑️ Assert ⬇
    // Final state check
    assertEq(hashBasedList.getHblLength(DEFAULT_NAMESPACE), 1);
  }

  function test_should_removeHblById() public {
    //* 🗂️ Arrange ⬇
    vm.startPrank(user);
    hashBasedList.addHbl(DEFAULT_NAMESPACE, DEFAULT_ID);
    // Initial state check
    assertEq(hashBasedList.getHblLength(DEFAULT_NAMESPACE), 1);
    //* 🎬 Act ⬇
    hashBasedList.removeHbl(DEFAULT_NAMESPACE, DEFAULT_ID);
    //* ☑️ Assert ⬇
    // Final state check
    assertEq(hashBasedList.getHblLength(DEFAULT_NAMESPACE), 0);
  }

  function PayMe_ShouldNot_WhenBalance0() public {
    address noBalanceAddress = payable(address(0));
    vm.startPrank(noBalanceAddress);
    // Initial state check
    uint256 initBalanceUser = address(noBalanceAddress).balance;
    uint256 initBalanceAdmin = address(admin).balance;
    assertEq(initBalanceUser, 0);
    assertGt(initBalanceAdmin, 1);
    // Event check
    vm.expectRevert();
    // Pay the admin
    // hashBasedList.payMe{ value: amount }();
    // Final state check
    uint256 finalBalanceUser = address(noBalanceAddress).balance;
    uint256 finalBalanceAdmin = address(admin).balance;
    assertEq(finalBalanceUser, initBalanceUser);
    assertEq(finalBalanceAdmin, initBalanceAdmin);
    vm.stopPrank();
  }
}
