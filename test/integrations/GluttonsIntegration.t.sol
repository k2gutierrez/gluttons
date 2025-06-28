// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test, console2} from "forge-std/Test.sol";
import {Gluttons} from "../../src/Gluttons.sol";
import {DeployGluttons} from "../../script/DeployGluttons.s.sol";
import {GluttonsFood} from "../../src/GluttonsFood.sol";

contract GluttonsIntegration is Test {
    Gluttons basicNft;
    GluttonsFood foodNft;

    DeployGluttons deployer;

    address USER = makeAddr("user");
    address USER2 = makeAddr("user2");
    address DEV1 = makeAddr("dev1");
    address DEV2 = makeAddr("dev2");
    address OWNER;

    uint256 constant STARTING_BALANCE = 400 ether;
    uint256 public constant PET_PRICE = 162e18;
    uint256 private constant FOOD7_PRICE = 7e18;

    function setUp() public {
        deployer = new DeployGluttons(DEV1, DEV2);
        (basicNft, foodNft, OWNER) = deployer.run();
        vm.deal(USER, STARTING_BALANCE);
        vm.deal(USER2, STARTING_BALANCE);
    }

    /*function testGetBasicUri() public view {
        
        string memory basicUri = basicNft.baseURI();
        assertEq(basicUri, "ipfs://QmcoeRsFYeHzPD9Gx84aKD3tjLUKjvPEMSmoPs2GQmHR1t/");
    }*/

    function testGetCounter() public {
        uint256 amount = 1;
        vm.prank(USER);
        basicNft.mintPet{value: (PET_PRICE * amount)}(amount);
        uint256 counter = basicNft.totalSupply();
        assert(counter == amount);
    }
    
}