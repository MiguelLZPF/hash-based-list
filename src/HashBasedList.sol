// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.0 <0.9.0;

/**
 * Position hash: hash(namespace, position)
 * Id hash: hash(namespace, id)
 */

abstract contract HashBasedList {
  /**
   * Example
   * hash(namespace, position) --> Payload
   *   positionHash --> Payload
   * mapping(bytes32 => Payload) private _payload;
   */
  // Hash(namespace, id) --> position
  //      idHash --> position
  mapping(bytes32 => uint8) private _hblPositionById;
  //   namespace --> length
  mapping(bytes32 => uint8) private _hblLength;

  function _addHbl(bytes32 namespace, bytes32 id) internal {
    bytes32 idHash = _calculateIdHash(namespace, id);
    _hblPositionById[idHash] = _hblLength[namespace];
    _hblLength[namespace]++;
  }

  function _removeHbl(bytes32 namespace, bytes32 id) internal {
    bytes32 idHash = _calculateIdHash(namespace, id);
    _hblPositionById[idHash] = 0;
    _hblLength[namespace]--;
  }

  function _setHblPosition(bytes32 namespace, bytes32 id, uint8 position) internal {
    bytes32 idHash = _calculateIdHash(namespace, id);
    require(position < _hblLength[namespace], "HBL: position out of range");
    _hblPositionById[idHash] = position;
  }

  function _getHblPosition(bytes32 namespace, bytes32 id) internal view returns (uint8) {
    bytes32 idHash = _calculateIdHash(namespace, id);
    return _hblPositionById[idHash];
  }

  function _getHblLength(bytes32 namespace) internal view returns (uint8) {
    return _hblLength[namespace];
  }

  function _calculateHashes(
    bytes32 namespace,
    bytes32 id
  ) internal view returns (bytes32 idHash, bytes32 positionHash, uint8 position) {
    idHash = _calculateIdHash(namespace, id);
    position = _hblPositionById[idHash];
    positionHash = keccak256(abi.encodePacked(namespace, position));
  }

  function _calculatePositionHash(
    bytes32 namespace,
    bytes32 id
  ) internal view returns (bytes32 positionHash) {
    (, positionHash, ) = _calculateHashes(namespace, id);
  }

  function _calculatePositionHash(
    bytes32 namespace,
    uint8 position
  ) internal pure returns (bytes32) {
    return keccak256(abi.encodePacked(namespace, position));
  }

  function _calculateIdHash(bytes32 namespace, bytes32 id) internal pure returns (bytes32) {
    return keccak256(abi.encodePacked(namespace, id));
  }
}
