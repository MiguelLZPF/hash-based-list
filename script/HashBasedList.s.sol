// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import { Script, console } from "forge-std/Script.sol";
import { HBLExample as HashBasedList } from "@src/HBLExample.sol";
import { Configuration, Deployment, DeploymentStoreInfo } from "@script/Configuration.s.sol";

/**
 * @title DeployCommand
 * @dev Struct representing a deployment command.
 */
struct DeployCommand {
  // Nothing in this case
  DeploymentStoreInfo storeInfo; // Deployment store information.
}

/**
 * @title HBLScript
 * @dev A script contract for deploying the HashBasedList contract and storing its deployment information.
 */
contract HBLScript is Script {
  string private constant CONTRACT_NAME = "HashBasedList";
  string private constant CONTRACT_FILE_NAME = "HashBasedList.sol";
  Configuration config = new Configuration();

  /**
   * @dev Deploys a new instance of the CONTACT_NAME contract.
   * @param store Determines whether to store the deployment information or not.
   * @param tag The tag associated with the deployment.
   * @return hashBasedList The deployed CONTACT_NAME contract instance.
   * @return deployment The deployment information.
   */
  function deploy(
    bool store,
    string calldata tag
  ) external returns (HashBasedList hashBasedList, Deployment memory deployment) {
    bytes32 tag_ = bytes32(bytes(tag));
    return
      this.deploy(DeployCommand({ storeInfo: DeploymentStoreInfo({ store: store, tag: tag_ }) }));
  }

  /**
   * @dev Deploys the HashBasedList contract and stores its deployment information.
   * @param command The deploy command containing the initial value for the HashBasedList contract.
   * @return hashBasedList The deployed HashBasedList contract.
   * @return deployment The deployment information of the HashBasedList contract.
   */
  function deploy(
    DeployCommand memory command
  ) external returns (HashBasedList hashBasedList, Deployment memory deployment) {
    // Only thing that is executed in the blockchain
    vm.startBroadcast();
    hashBasedList = new HashBasedList();
    vm.stopBroadcast();
    // Generate deployment data
    deployment = Deployment({
      bytecodeHash: keccak256(vm.getCode(CONTRACT_FILE_NAME)),
      chainId: block.chainid,
      logicAddr: address(hashBasedList),
      name: bytes32(bytes(CONTRACT_NAME)),
      proxyAddr: address(0),
      tag: command.storeInfo.tag,
      timestamp: block.timestamp
    });
    // Store the deployment
    if (command.storeInfo.store) {
      config.storeDeployment(deployment);
    }
    return (hashBasedList, deployment);
  }
}
