// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.0 <0.9.0;

import { HashBasedList } from "@src/HashBasedList.sol";

contract HBLExample is HashBasedList {
  function addHbl(bytes32 namespace, bytes32 id) external {
    _addHbl(namespace, id);
  }

  function removeHbl(bytes32 namespace, bytes32 id, bytes32 latestId) external {
    _removeHbl(namespace, id, latestId);
  }

  function initHblLength(bytes32 namespace) external {
    _initHblLength(namespace);
  }

  function initHblPosition(bytes32 namespace, bytes32 id) external {
    _initHblPosition(namespace, id);
  }

  function setHblPosition(bytes32 namespace, bytes32 id, uint8 position) external {
    _setHblPosition(namespace, id, position);
  }

  function getHblLength(bytes32 namespace) external view returns (uint8) {
    return _getHblLength(namespace);
  }

  function calculateHashes(
    bytes32 namespace,
    bytes32 id
  ) external view returns (bytes32 idHash, bytes32 positionHash, uint8 position) {
    return _calculateHashes(namespace, id);
  }

  function calculatePositionHash(
    bytes32 namespace,
    uint8 position
  ) external pure returns (bytes32) {
    return _calculatePositionHash(namespace, position);
  }

  function getHblPosition(bytes32 namespace, bytes32 id) external view returns (uint8) {
    return _getHblPosition(namespace, id);
  }
}
