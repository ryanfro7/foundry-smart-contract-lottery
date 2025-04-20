// Layout of Contract:
// version
// imports
// errors
// interfaces, libraries, contracts
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// view & pure functions

//SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {VRFConsumerBaseV2Plus} from "@chainlink/contracts@1.1.1/src/v0.8/vrf/dev/VRFConsumerBaseV2Plus.sol";

/**
 * @title A sample raffle contract
 * @author Ryan M. Froelich
 * @notice This contract is a simple raffle contract that allows users to enter a raffle by sending ether. Built to learn about Solidity and smart contracts. 
 * @dev Implements Chainlink VRFv2.5
 */
contract Raffle {
    /* Errors*/
    error Raffle__SendMoreToEnterRaffle();

    uint256 private immutable i_entranceFee;
    //@dev The duration of the lotter in seconds
    uint256 private immutable i_interval;
    address payable[] s_players;
    uint256 private s_lastTimeStamp;

    /* Events */
event RaffleEntered(address indexed player);



    // What data strucuture should we use to store the players?
    constructor(uint256 entranceFee, uint256 interval) {
        i_entranceFee = entranceFee;
        i_interval = interval;
        s_lastTimeStamp = block.timestamp;
    }

    function enterRaffle() external payable {
        //Following is gas inefficient because it stores a string. 
        //require(msg.value >= i_entranceFee, "Not enough ETH sent to enter the raffle")
        //Following doesnt work in 0.8.19, and is not gas efficient.
        //require(msg.value >= i_entranceFeee, SendMoreToEnterRaffle());
        if(msg.value < i_entranceFee) {
            revert Raffle__SendMoreToEnterRaffle();
        }
        s_players.push(payable(msg.sender));

        emit RaffleEntered(msg.sender);
    }

    //1. Get a random number
    //2. Use random number to pick a winner
    //3. Be automatically called
    function pickWinner() external {
        // check to see if enough time has passed
        if ((block.timestamp - s_lastTimeStamp) > i_interval){
            revert();
        }
    uint256 requestID = s_vrfCoordinator.requestRandomWords(VRFV2PlusClient.RandomWordsRequest({
        keyHash: keyHash,
        subId: subId,
        requestConfirmations: requestConfirmations,
        callbackGasLimit: callbackGasLimit,
        numWords: numWords,
        extraArgs: VRFV2PlusClient._argsToBytes(VRFV2PlusClient.ExtraArgsV1({nativePayment: true}))
  })
);


    }

    /** 
     * Getter Functions 
     * */
    function getEntranceFee() external view returns (uint256) {
        return i_entranceFee;
    }
}
