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
  bytes32 private constant OTHER_ID = bytes32("ThisIsAnotherId");
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

  function test_should_removeFirstHbl() public {
    //* 🗂️ Arrange ⬇
    vm.startPrank(user);
    hashBasedList.addHbl(DEFAULT_NAMESPACE, DEFAULT_ID);
    // Initial state check
    assertEq(hashBasedList.getHblLength(DEFAULT_NAMESPACE), 1);
    assertEq(hashBasedList.getHblPosition(DEFAULT_NAMESPACE, DEFAULT_ID), 1);
    //* 🎬 Act ⬇
    hashBasedList.removeHbl(DEFAULT_NAMESPACE, DEFAULT_ID, DEFAULT_ID);
    //* ☑️ Assert ⬇
    // Final state check
    assertEq(hashBasedList.getHblLength(DEFAULT_NAMESPACE), 0);
    assertEq(hashBasedList.getHblPosition(DEFAULT_NAMESPACE, DEFAULT_ID), 0);
  }

  function test_should_removeInBetweenHbl() public {
    //* 🗂️ Arrange ⬇
    vm.startPrank(user);
    bytes32 ANOTHER_ID = "thisIsAnotherId";
    bytes32 YET_ANOTHER = "thisIsYetAnotherId";
    hashBasedList.addHbl(DEFAULT_NAMESPACE, DEFAULT_ID);
    hashBasedList.addHbl(DEFAULT_NAMESPACE, ANOTHER_ID);
    hashBasedList.addHbl(DEFAULT_NAMESPACE, YET_ANOTHER);
    // Initial state check
    assertEq(hashBasedList.getHblLength(DEFAULT_NAMESPACE), 3);
    assertEq(hashBasedList.getHblPosition(DEFAULT_NAMESPACE, DEFAULT_ID), 1);
    assertEq(hashBasedList.getHblPosition(DEFAULT_NAMESPACE, ANOTHER_ID), 2);
    assertEq(hashBasedList.getHblPosition(DEFAULT_NAMESPACE, YET_ANOTHER), 3);
    //* 🎬 Act ⬇
    hashBasedList.removeHbl(DEFAULT_NAMESPACE, ANOTHER_ID, YET_ANOTHER);
    //* ☑️ Assert ⬇
    // Final state check
    assertEq(hashBasedList.getHblLength(DEFAULT_NAMESPACE), 2);
    assertEq(hashBasedList.getHblPosition(DEFAULT_NAMESPACE, DEFAULT_ID), 1);
    assertEq(hashBasedList.getHblPosition(DEFAULT_NAMESPACE, YET_ANOTHER), 2);
    assertEq(hashBasedList.getHblPosition(DEFAULT_NAMESPACE, ANOTHER_ID), 0);
  }

  function test_shouldNot_removeHbl_badLatestId() public {
    //* 🗂️ Arrange ⬇
    vm.startPrank(user);
    bytes32 ANOTHER_ID = "thisIsAnotherId";
    bytes32 YET_ANOTHER = "thisIsYetAnotherId";
    hashBasedList.addHbl(DEFAULT_NAMESPACE, DEFAULT_ID);
    hashBasedList.addHbl(DEFAULT_NAMESPACE, ANOTHER_ID);
    hashBasedList.addHbl(DEFAULT_NAMESPACE, YET_ANOTHER);
    // Initial state check
    assertEq(hashBasedList.getHblLength(DEFAULT_NAMESPACE), 3);
    assertEq(hashBasedList.getHblPosition(DEFAULT_NAMESPACE, DEFAULT_ID), 1);
    assertEq(hashBasedList.getHblPosition(DEFAULT_NAMESPACE, ANOTHER_ID), 2);
    assertEq(hashBasedList.getHblPosition(DEFAULT_NAMESPACE, YET_ANOTHER), 3);
    //* 🎬 Act ⬇
    vm.expectRevert("HBL: lId is not the last item");
    hashBasedList.removeHbl(DEFAULT_NAMESPACE, ANOTHER_ID, DEFAULT_ID); //! DEFAULT_ID is not the last item
    //* ☑️ Assert ⬇
    // Final state check
    assertEq(hashBasedList.getHblLength(DEFAULT_NAMESPACE), 3);
    assertEq(hashBasedList.getHblPosition(DEFAULT_NAMESPACE, DEFAULT_ID), 1);
    assertEq(hashBasedList.getHblPosition(DEFAULT_NAMESPACE, ANOTHER_ID), 2);
    assertEq(hashBasedList.getHblPosition(DEFAULT_NAMESPACE, YET_ANOTHER), 3);
  }

  function test_should_initHblLength() public {
    //* 🗂️ Arrange ⬇
    vm.startPrank(user);
    bytes32 ANOTHER_ID = "thisIsAnotherId";
    bytes32 YET_ANOTHER = "thisIsYetAnotherId";
    hashBasedList.addHbl(DEFAULT_NAMESPACE, DEFAULT_ID);
    hashBasedList.addHbl(DEFAULT_NAMESPACE, ANOTHER_ID);
    hashBasedList.addHbl(DEFAULT_NAMESPACE, YET_ANOTHER);
    // Initial state check
    assertEq(hashBasedList.getHblLength(DEFAULT_NAMESPACE), 3);
    assertEq(hashBasedList.getHblPosition(DEFAULT_NAMESPACE, DEFAULT_ID), 1);
    assertEq(hashBasedList.getHblPosition(DEFAULT_NAMESPACE, ANOTHER_ID), 2);
    assertEq(hashBasedList.getHblPosition(DEFAULT_NAMESPACE, YET_ANOTHER), 3);
    //* 🎬 Act ⬇
    hashBasedList.initHblLength(DEFAULT_NAMESPACE);
    //* ☑️ Assert ⬇
    // Final state check
    assertEq(hashBasedList.getHblLength(DEFAULT_NAMESPACE), 0);
    assertEq(hashBasedList.getHblPosition(DEFAULT_NAMESPACE, DEFAULT_ID), 1);
    assertEq(hashBasedList.getHblPosition(DEFAULT_NAMESPACE, ANOTHER_ID), 2);
    assertEq(hashBasedList.getHblPosition(DEFAULT_NAMESPACE, YET_ANOTHER), 3);
  }

  function test_should_initHblPosition() public {
    //* 🗂️ Arrange ⬇
    vm.startPrank(user);
    bytes32 ANOTHER_ID = "thisIsAnotherId";
    bytes32 YET_ANOTHER = "thisIsYetAnotherId";
    hashBasedList.addHbl(DEFAULT_NAMESPACE, DEFAULT_ID);
    hashBasedList.addHbl(DEFAULT_NAMESPACE, ANOTHER_ID);
    hashBasedList.addHbl(DEFAULT_NAMESPACE, YET_ANOTHER);
    // Initial state check
    assertEq(hashBasedList.getHblLength(DEFAULT_NAMESPACE), 3);
    assertEq(hashBasedList.getHblPosition(DEFAULT_NAMESPACE, DEFAULT_ID), 1);
    assertEq(hashBasedList.getHblPosition(DEFAULT_NAMESPACE, ANOTHER_ID), 2);
    assertEq(hashBasedList.getHblPosition(DEFAULT_NAMESPACE, YET_ANOTHER), 3);
    //* 🎬 Act ⬇
    hashBasedList.initHblPosition(DEFAULT_NAMESPACE, DEFAULT_ID);
    hashBasedList.initHblPosition(DEFAULT_NAMESPACE, ANOTHER_ID);
    hashBasedList.initHblPosition(DEFAULT_NAMESPACE, YET_ANOTHER);
    //* ☑️ Assert ⬇
    // Final state check
    assertEq(hashBasedList.getHblLength(DEFAULT_NAMESPACE), 3);
    assertEq(hashBasedList.getHblPosition(DEFAULT_NAMESPACE, DEFAULT_ID), 0);
    assertEq(hashBasedList.getHblPosition(DEFAULT_NAMESPACE, ANOTHER_ID), 0);
    assertEq(hashBasedList.getHblPosition(DEFAULT_NAMESPACE, YET_ANOTHER), 0);
  }

  function test_should_setHblPosition() public {
    //* 🗂️ Arrange ⬇
    vm.startPrank(user);
    hashBasedList.addHbl(DEFAULT_NAMESPACE, DEFAULT_ID);
    hashBasedList.addHbl(DEFAULT_NAMESPACE, OTHER_ID);
    // Initial state check
    assertEq(hashBasedList.getHblLength(DEFAULT_NAMESPACE), 2);
    assertEq(hashBasedList.getHblPosition(DEFAULT_NAMESPACE, DEFAULT_ID), 1);
    assertEq(hashBasedList.getHblPosition(DEFAULT_NAMESPACE, OTHER_ID), 2);
    //* 🎬 Act ⬇
    // Exchange positions
    hashBasedList.setHblPosition(DEFAULT_NAMESPACE, DEFAULT_ID, 2);
    hashBasedList.setHblPosition(DEFAULT_NAMESPACE, OTHER_ID, 1);
    //* ☑️ Assert ⬇
    // Final state check
    assertEq(hashBasedList.getHblLength(DEFAULT_NAMESPACE), 2);
    assertEq(hashBasedList.getHblPosition(DEFAULT_NAMESPACE, DEFAULT_ID), 2);
    assertEq(hashBasedList.getHblPosition(DEFAULT_NAMESPACE, OTHER_ID), 1);
  }

  function test_shouldNot_setHblPosition_WhenPositionOutOfRange() public {
    //* 🗂️ Arrange ⬇
    vm.startPrank(user);
    hashBasedList.addHbl(DEFAULT_NAMESPACE, DEFAULT_ID);
    // Initial state check
    assertEq(hashBasedList.getHblLength(DEFAULT_NAMESPACE), 1);
    //* 🎬 Act ⬇
    // Cannot set position 0
    vm.expectRevert("HBL: position out of range");
    hashBasedList.setHblPosition(DEFAULT_NAMESPACE, DEFAULT_ID, 0);
    // Cannot set position > length
    vm.expectRevert("HBL: position out of range");
    hashBasedList.setHblPosition(DEFAULT_NAMESPACE, DEFAULT_ID, 2);
    // Cannot set position >> length
    vm.expectRevert("HBL: position out of range");
    hashBasedList.setHblPosition(DEFAULT_NAMESPACE, DEFAULT_ID, 150);
    //* ☑️ Assert ⬇
    // Final state check
    assertEq(hashBasedList.getHblLength(DEFAULT_NAMESPACE), 1);
  }

  function test_should_getHblLength() public {
    //* 🗂️ Arrange ⬇
    vm.startPrank(user);
    hashBasedList.addHbl(DEFAULT_NAMESPACE, DEFAULT_ID);
    // Initial state check
    assertEq(hashBasedList.getHblLength(DEFAULT_NAMESPACE), 1);
    //* 🎬 Act ⬇
    uint8 length = hashBasedList.getHblLength(DEFAULT_NAMESPACE);
    //* ☑️ Assert ⬇
    // Final state check
    assertEq(length, 1);
  }

  function test_should_calculateHashes() public {
    //* 🗂️ Arrange ⬇
    vm.startPrank(user);
    hashBasedList.addHbl(DEFAULT_NAMESPACE, DEFAULT_ID);
    // Initial state check
    assertEq(hashBasedList.getHblLength(DEFAULT_NAMESPACE), 1);
    //* 🎬 Act ⬇
    (bytes32 idHash, bytes32 positionHash, uint8 position) = hashBasedList.calculateHashes(
      DEFAULT_NAMESPACE,
      DEFAULT_ID
    );
    //* ☑️ Assert ⬇
    // Final state check
    assertEq(idHash, keccak256(abi.encodePacked(DEFAULT_NAMESPACE, DEFAULT_ID)));
    assertEq(positionHash, keccak256(abi.encodePacked(DEFAULT_NAMESPACE, position)));
    assertEq(position, 1);
  }

  function test_should_calculatePositionHash() public {
    //* 🗂️ Arrange ⬇
    vm.startPrank(user);
    // Initial state check
    //* 🎬 Act ⬇
    bytes32 positionHash = hashBasedList.calculatePositionHash(DEFAULT_NAMESPACE, 1);
    //* ☑️ Assert ⬇
    // Final state check
    assertEq(positionHash, keccak256(abi.encodePacked(DEFAULT_NAMESPACE, uint8(1))));
  }
}
