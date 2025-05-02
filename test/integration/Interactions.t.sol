// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {console, Test} from "forge-std/Test.sol";
import {Raffle} from "../../src/Raffle.sol";
import {DeployRaffle} from "../../script/DeployRaffle.s.sol";
import {CreateSubscription, FundSubscription, AddConsumer} from "../../script/Interactions.s.sol";
import {VRFCoordinatorV2PlusMock} from "lib/chainlink/contracts/src/v0.8/vrf/mocks/VRFCoordinatorV2PlusMock.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";

contract InteractionsTest is Test {
    Raffle raffle;
    HelperConfig helperConfig;

    address public vrfCoordinator;
    uint256 public deployerKey;
    address public linkToken;

    function setUp() public {
        DeployRaffle deployRaffle = new DeployRaffle();
        (raffle, helperConfig) = deployRaffle.deployContract();
        HelperConfig.NetworkConfig memory config = helperConfig.getConfig();
        vrfCoordinator = config.vrfCoordinator;
        deployerKey = config.deployerKey;
        linkToken = config.link;
    }

    function testCreateSubscription() public {
        CreateSubscription createSubscription = new CreateSubscription();
        uint256 subId = createSubscription.createSubscription(vrfCoordinator, deployerKey);
        assert(subId != 0);
        (, , , address owner,) = VRFCoordinatorV2PlusMock(vrfCoordinator).getSubscription(subId);
        assertEq(owner, vm.addr(deployerKey));
    }

    function testFundSubscription() public {
        // Only create and fund ONE subscription, and check that one
        CreateSubscription createSubscription = new CreateSubscription();
        uint256 subId = createSubscription.createSubscription(vrfCoordinator, deployerKey);

        (uint96 beforeBalance, , , , ) = VRFCoordinatorV2PlusMock(vrfCoordinator).getSubscription(subId);
        console.log("Balance before funding:", beforeBalance);

        FundSubscription fundSubscription = new FundSubscription();
        fundSubscription.fundSubscription(vrfCoordinator, subId, linkToken, deployerKey);

        (uint96 afterBalance, , , , ) = VRFCoordinatorV2PlusMock(vrfCoordinator).getSubscription(subId);
        console.log("Balance after funding:", afterBalance);

        assert(afterBalance != 0);
    }

    function testAddConsumer() public {
        CreateSubscription createSubscription = new CreateSubscription();
        uint256 subId = createSubscription.createSubscription(vrfCoordinator, deployerKey);
        FundSubscription fundSubscription = new FundSubscription();
        fundSubscription.fundSubscription(vrfCoordinator, subId, linkToken, deployerKey);
        AddConsumer addConsumer = new AddConsumer();
        addConsumer.addConsumer(address(raffle), vrfCoordinator, subId, deployerKey);

        // Check if raffle is a consumer
        (, , , , address[] memory consumers) = VRFCoordinatorV2PlusMock(vrfCoordinator).getSubscription(subId);
        bool isAdded = false;
        for (uint256 i = 0; i < consumers.length; i++) {
            if (consumers[i] == address(raffle)) {
                isAdded = true;
                break;
            }
        }
        assertTrue(isAdded);
    }
}