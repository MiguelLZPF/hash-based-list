// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.0 <0.9.0;

//* Leyend 📜
// Position hash: hash(namespace, position)
// Id hash: hash(namespace, id)

string constant REVERT_OUT_OF_RANGE = "HBL: position out of range";

/**
 * @title HashBasedList
 * @dev Abstract contract for a hash-based list implementation.
 */
abstract contract HashBasedList {
  /**
   * Example
   * hash(namespace, position) --> Payload
   *   positionHash --> Payload
   * mapping(bytes32 => Payload) private _payload;
   */
  /**
   * @dev Mapping to store the position of each item in the list.
   * @dev Mapping key: hash(namespace, id)
   * @dev Mapping value: position
   */
  // Hash(namespace, id) --> position
  //      idHash --> position
  mapping(bytes32 => uint8) private _hblPositionById;
  /**
   * @dev Mapping to store the length of the list for each namespace.
   * @dev Mapping key: namespace
   * @dev Mapping value: length
   */
  //   namespace --> length
  mapping(bytes32 => uint8) private _hblLength;

  /**
   * @dev Adds an item to the hash-based list.
   * @param namespace The namespace of the item.
   * @param id The ID of the item.
   */
  function _addHbl(bytes32 namespace, bytes32 id) internal {
    bytes32 idHash = _calculateIdHash(namespace, id);
    _hblPositionById[idHash] = _hblLength[namespace] + 1; //! Reserve 0 for non-existent --> Last position == length
    _hblLength[namespace]++;
  }

  /**
   * @dev Removes an item from the hash-based list.
   * @param namespace The namespace of the item.
   * @param id The ID of the item.
   */
  function _removeHbl(bytes32 namespace, bytes32 id) internal {
    bytes32 idHash = _calculateIdHash(namespace, id);
    _hblPositionById[idHash] = 0;
    _hblLength[namespace]--;
  }

  /**
   * @dev Sets the position of an item in the hash-based list.
   * @param namespace The namespace of the item.
   * @param id The ID of the item.
   * @param position The new position of the item.
   */
  function _setHblPosition(bytes32 namespace, bytes32 id, uint8 position) internal {
    bytes32 idHash = _calculateIdHash(namespace, id);
    require(position <= _hblLength[namespace] && position > 0, REVERT_OUT_OF_RANGE);
    _hblPositionById[idHash] = position;
  }

  /**
   * @dev Gets the position of an item in the hash-based list.
   * @param namespace The namespace of the item.
   * @param id The ID of the item.
   * @return The position of the item.
   */
  function _getHblPosition(bytes32 namespace, bytes32 id) internal view returns (uint8) {
    bytes32 idHash = _calculateIdHash(namespace, id);
    return _hblPositionById[idHash];
  }

  /**
   * @dev Gets the length of the hash-based list for a given namespace.
   * @param namespace The namespace of the list.
   * @return The length of the list.
   */
  function _getHblLength(bytes32 namespace) internal view returns (uint8) {
    return _hblLength[namespace];
  }

  /**
   * @dev Calculates the hashes and position of an item in the hash-based list.
   * @param namespace The namespace of the item.
   * @param id The ID of the item.
   * @return idHash The hash of the item's ID.
   * @return positionHash The hash of the item's position.
   * @return position The position of the item.
   */
  function _calculateHashes(
    bytes32 namespace,
    bytes32 id
  ) internal view returns (bytes32 idHash, bytes32 positionHash, uint8 position) {
    idHash = _calculateIdHash(namespace, id);
    position = _hblPositionById[idHash];
    positionHash = keccak256(abi.encodePacked(namespace, position));
  }

  /**
   * @dev Calculates the hash of an item's position in the hash-based list.
   * @param namespace The namespace of the item.
   * @param id The ID of the item.
   * @return positionHash The hash of the item's position.
   */
  function _calculatePositionHash(
    bytes32 namespace,
    bytes32 id
  ) internal view returns (bytes32 positionHash) {
    (, positionHash, ) = _calculateHashes(namespace, id);
  }

  /**
   * @dev Calculates the hash of a position in the hash-based list.
   * @param namespace The namespace of the list.
   * @param position The position in the list.
   * @return The hash of the position.
   */
  function _calculatePositionHash(
    bytes32 namespace,
    uint8 position
  ) internal pure returns (bytes32) {
    return keccak256(abi.encodePacked(namespace, position));
  }

  /**
   * @dev Calculates the hash of an item's ID in the hash-based list.
   * @param namespace The namespace of the item.
   * @param id The ID of the item.
   * @return The hash of the item's ID.
   */
  function _calculateIdHash(bytes32 namespace, bytes32 id) internal pure returns (bytes32) {
    return keccak256(abi.encodePacked(namespace, id));
  }
}
