// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {Gluttons} from "../src/Gluttons.sol";
import {GluttonsFood} from "../src/GluttonsFood.sol";

contract DeployGluttons is Script {

    //string constant NAME = "Gluttons";
    //string constant SYMBOL = "GLTNS";
    //string constant URI = "ipfs://QmcoeRsFYeHzPD9Gx84aKD3tjLUKjvPEMSmoPs2GQmHR1t/";
    //address constant DEV1 = 0xca067E20db2cDEF80D1c7130e5B71C42c0305529;
    //address constant DEV2 = 0xca067E20db2cDEF80D1c7130e5B71C42c0305529;
    address constant i_dev1 = 0xca067E20db2cDEF80D1c7130e5B71C42c0305529; // Carlos
    address constant i_dev2 = 0xbfAb062f38dd327c823e747C8Cd97853B7114241; // Memo

    function run() external returns(Gluttons, GluttonsFood, address){
        vm.startBroadcast();
        Gluttons basicNFT = new Gluttons(i_dev1, i_dev2);
        GluttonsFood foodNft = new GluttonsFood(i_dev1, i_dev2, address(basicNFT));
        vm.stopBroadcast();
        address owner = basicNFT.owner();
        vm.startPrank(owner);
        basicNFT.setFoodContract(address(foodNft));
        basicNFT.setOracle(owner);
        vm.stopPrank();

        return (basicNFT, foodNft, owner);
    }
}