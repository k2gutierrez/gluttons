// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title NFT Gamefied expierence to feed a Glutton daily, all the money 
 * except 10% goes to a pool, last man standing get the pool or if a vote
 * is made the pool can be divided to the last survivors.
 * @author Carlos Enrique Gutiérrez Chimal
 * @author Github - k2gutierrez
 * @author X - CarlosDappsDev.eth
 * @author 0xc6D11bF969C4E34e923ec476FE76f7D7ad0Ce685
 */
contract NftGame is Ownable {

    constructor() Ownable(msg.sender){}
    
    function start() public {}

}

//Checks, effects, interactions

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
// internal & private view & pure functions
// external & public view & pure functions