// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {VRFCoordinatorV2PlusMock} from "lib/chainlink/contracts/src/v0.8/vrf/mocks/VRFCoordinatorV2PlusMock.sol";
import {LinkToken} from "test/mocks/LinkToken.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";

uint256 constant LOCAL_CHAIN_ID = 31337;

contract CreateSubscription is Script {
    function createSubscription(address vrfCoordinator, uint256 deployerKey) public returns (uint256) {
        require(vrfCoordinator != address(0), "Invalid VRF Coordinator address");
        console.log("CreateSubscription: vrfCoordinator:", vrfCoordinator);
        console.log("CreateSubscription: deployerKey:", deployerKey);
        vm.startBroadcast(deployerKey);
        uint256 subId = VRFCoordinatorV2PlusMock(vrfCoordinator).createSubscription();
        vm.stopBroadcast();
        console.log("Created subscription with ID:", subId);
        return subId;
    }

    function run(address vrfCoordinator, uint256 deployerKey) external returns (uint256) {
        return createSubscription(vrfCoordinator, deployerKey);
    }
}

contract FundSubscription is Script {
    uint256 public constant FUND_AMOUNT = 3 ether; // 3 LINK

    function fundSubscription(address vrfCoordinator, uint256 subscriptionId, address linkToken, uint256 deployerKey)
        public
    {
        require(vrfCoordinator != address(0), "Invalid VRF Coordinator address");
        require(subscriptionId != 0, "Invalid subscriptionId");
        console.log("FundSubscription: vrfCoordinator:", vrfCoordinator);
        console.log("FundSubscription: subscriptionId:", subscriptionId);
        console.log("FundSubscription: linkToken:", linkToken);
        console.log("FundSubscription: deployerKey:", deployerKey);
        if (block.chainid == LOCAL_CHAIN_ID) {
            vm.startBroadcast(deployerKey);
            VRFCoordinatorV2PlusMock(vrfCoordinator).fundSubscription(subscriptionId, uint96(FUND_AMOUNT));
            vm.stopBroadcast();
        } else {
            vm.startBroadcast(deployerKey);
            LinkToken(linkToken).transferAndCall(vrfCoordinator, FUND_AMOUNT, abi.encode(subscriptionId));
            vm.stopBroadcast();
        }
        console.log("Funded subscription:", subscriptionId);
    }

    function run(address vrfCoordinator, uint256 subscriptionId, address linkToken, uint256 deployerKey) external {
        fundSubscription(vrfCoordinator, subscriptionId, linkToken, deployerKey);
    }
}

contract AddConsumer is Script {
    function addConsumer(address contractToAddToVrf, address vrfCoordinator, uint256 subId, uint256 deployerKey)
        public
    {
        require(vrfCoordinator != address(0), "Invalid VRF Coordinator address");
        require(subId != 0, "Invalid subscriptionId");
        console.log("AddConsumer: contractToAddToVrf:", contractToAddToVrf);
        console.log("AddConsumer: vrfCoordinator:", vrfCoordinator);
        console.log("AddConsumer: subId:", subId);
        console.log("AddConsumer: deployerKey:", deployerKey);
        vm.startBroadcast(deployerKey);
        VRFCoordinatorV2PlusMock(vrfCoordinator).addConsumer(subId, contractToAddToVrf);
        vm.stopBroadcast();
        console.log("Added consumer:", contractToAddToVrf, "to subscription:", subId);
    }

    function run(address contractToAddToVrf, address vrfCoordinator, uint256 subId, uint256 deployerKey) external {
        addConsumer(contractToAddToVrf, vrfCoordinator, subId, deployerKey);
    }
}
