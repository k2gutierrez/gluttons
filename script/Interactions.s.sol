// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script, console2} from "forge-std/Script.sol";
import {Gluttons} from "../src/Gluttons.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";

contract MintBasicNFT is Script {

    address MAIN_USER = makeAddr("user");
    uint256 private constant PET_PRICE = 1e5;
    
    function run() external {
        // address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("Gluttons", block.chainid);
        address gluttons = 0x1e0afD078d942deb42f2a72bB4857C6D6a8636f6;
        mintNftOnContract(gluttons);
    }

    function mintNftOnContract(address contractAddress) public {
        uint256 amount = 1;
        address owner = Gluttons(payable(contractAddress)).owner();
        vm.startBroadcast(owner);
        Gluttons(payable(contractAddress)).mintPet{value: (PET_PRICE * amount)}(amount);
        vm.stopBroadcast();
    }

}