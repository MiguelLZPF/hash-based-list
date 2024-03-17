// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.0 <0.9.0;

import { HashBasedList } from "@src/HashBasedList.sol";

contract HBLExample is HashBasedList {
  function addHbl(bytes32 namespace, bytes32 id) external {
    _addHbl(namespace, id);
  }

  function addHbl(bytes32 idHash) external {
    _addHbl(idHash);
  }

  function removeHbl(bytes32 namespace, bytes32 id) external {
    _removeHbl(namespace, id);
  }

  function removeHbl(bytes32 idHash) external {
    _removeHbl(idHash);
  }

  function setHblPosition(bytes32 namespace, bytes32 id, uint8 position) external {
    _setHblPosition(namespace, id, position);
  }

  function setHblPosition(bytes32 idHash, uint8 position) external {
    _setHblPosition(idHash, position);
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

  function calculatePositioHash(bytes32 namespace, bytes32 id) external view returns (bytes32) {
    return _calculatePositionHash(namespace, id);
  }

  function calculatePositionHash(
    bytes32 namespace,
    uint8 position
  ) external pure returns (bytes32) {
    return _calculatePositionHash(namespace, position);
  }
}
