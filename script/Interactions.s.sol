// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script, console2} from "forge-std/Script.sol";
import {Gluttons} from "../src/Gluttons.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";

contract MintBasicNFT is Script {

    address MAIN_USER = makeAddr("user");
    
    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("Gluttons", block.chainid);
        mintNftOnContract(mostRecentlyDeployed);
    }

    function mintNftOnContract(address contractAddress) public {
        uint256 amount = 1;
        vm.startBroadcast(MAIN_USER);
        Gluttons(payable(contractAddress)).mintPet(amount);
        vm.stopBroadcast();
    }

}
