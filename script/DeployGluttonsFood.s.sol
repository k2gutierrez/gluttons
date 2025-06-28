// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {GluttonsFood} from "../src/GluttonsFood.sol";
import {Gluttons} from "../src/Gluttons.sol";

contract DeployGluttonsFood is Script {

    //string constant NAME = "Gluttons";
    //string constant SYMBOL = "GLTNS";
    //string constant URI = "ipfs://QmcoeRsFYeHzPD9Gx84aKD3tjLUKjvPEMSmoPs2GQmHR1t/";
    //address constant DEV1 = 0xca067E20db2cDEF80D1c7130e5B71C42c0305529;
    //address constant DEV2 = 0xca067E20db2cDEF80D1c7130e5B71C42c0305529;

    address i_dev1;
    address i_dev2;

    constructor (address dev1, address dev2) {
        i_dev1 = dev1;
        i_dev2 = dev2;
    }

    function run() external returns(GluttonsFood, Gluttons){

        vm.startBroadcast();
        Gluttons basicNFT = new Gluttons(i_dev1, i_dev2);
        GluttonsFood foodNFT = new GluttonsFood(i_dev1, i_dev2, address(basicNFT));
        vm.stopBroadcast();
        return (foodNFT, basicNFT);
    }
}