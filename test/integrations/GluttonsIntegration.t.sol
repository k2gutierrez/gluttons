// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test, console2} from "forge-std/Test.sol";
import {Gluttons} from "../../src/Gluttons.sol";
import {DeployGluttons} from "../../script/DeployGluttons.s.sol";
import {GluttonsFood} from "../../src/GluttonsFood.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

//////////notes
/**
 * agregué contador de veces que se ha alimentado falta probar
 * debo agregar que sólo se pueda alimentar una vez por día y probar - agregado falta probar
 * 
 */

contract GluttonsIntegration is Test {
    Gluttons basicNft;
    GluttonsFood foodNft;

    DeployGluttons deployer;

    address USER = makeAddr("user");
    address USER2 = makeAddr("user2");
    address DEV1 = makeAddr("dev1");
    address DEV2 = makeAddr("dev2");
    address ORACLE = makeAddr("oracle");
    address OWNER;

    uint256 constant STARTING_BALANCE = 400 ether;
    uint256 public constant PET_PRICE = 100e18;
    uint256 private constant FOOD7_PRICE = 14e18;
    uint256 private constant FOOD30_PRICE = 30e18;
    uint256 private constant STARVATION_TIME = 12 hours;

    function setUp() public {
        deployer = new DeployGluttons(DEV1, DEV2);
        (basicNft, foodNft, OWNER) = deployer.run();
        vm.deal(USER, STARTING_BALANCE);
        vm.deal(USER2, STARTING_BALANCE);
        vm.deal(ORACLE, STARTING_BALANCE);
        uint256 mintAmount = 3;

        vm.startPrank(basicNft.owner());
        //body 4, pattern 4, mouth 39, lefteyes 36, righteyes 36
        uint256[5] memory traits = [uint256(3),uint256(1), uint256(16), uint256(22), uint256(8)];
        basicNft.setTokenTraits(1, traits);
        basicNft.setOracle(ORACLE);
        vm.stopPrank();

        vm.startPrank(USER);
        basicNft.mintPet{value: (PET_PRICE * mintAmount)}(mintAmount);
        basicNft.buyFoodPackMonth{value: FOOD30_PRICE}(USER);
        basicNft.buyFoodPackMonth{value: FOOD30_PRICE}(USER);
        vm.stopPrank();
    }

    function testGetTokenUri() public view {

        uint256 tokenId = 1;
        
        string memory basicUri = basicNft.tokenURI(tokenId);
        console2.log(basicUri);
    }

    /*function testGetTokenImage() public view {

        uint256 tokenId = 1;
        
        string memory basicUri = basicNft.generateSVG(tokenId);
        string memory image = string(
            abi.encodePacked("data:image/svg+xml;base64, ", Base64.encode(bytes(basicUri)))
        );
        console2.log(image);
    }*/

    function testGetCounter() public view {
        
        uint256 balanceOfUser = basicNft.balanceOf(USER);
        uint256 totalSupply = basicNft.totalSupply();

        console2.log("totalSupply: ", totalSupply);
        console2.log("balance of USER: ", balanceOfUser);
        assert(balanceOfUser == totalSupply);
    }

    function testEggChangeAfter7Feeds() public {
        uint256 timesFed = 7;
        uint256 tokenId = 1;
        uint256 time = block.timestamp;
        for (uint256 i = 0; i < timesFed; i++){
            vm.startPrank(USER);
            basicNft.feedPet(USER, tokenId, i);
            basicNft.feedPet(USER, 2, i+7);
            basicNft.feedPet(USER, 3, i+14);
            vm.stopPrank();
            // Fast forward to starvation time
            time = time + STARVATION_TIME;
            vm.warp(time);
            vm.startPrank(ORACLE);
            basicNft.executeReaper();
            vm.stopPrank();
        }

        string memory basicUri = basicNft.tokenURI(tokenId);
        console2.log(basicUri);

    }

    function testEggChangeAfter14Feeds() public {
        uint256 timesFed = 14;
        uint256 tokenId = 1;
        uint256 time = block.timestamp;
        for (uint256 i = 0; i < timesFed; i++){
            vm.startPrank(USER);
            basicNft.feedPet(USER, tokenId, i);
            basicNft.feedPet(USER, (tokenId+1), i+14);
            basicNft.feedPet(USER, (tokenId + 2), i+28);
            vm.stopPrank();
            // Fast forward to starvation time
            time = time + STARVATION_TIME;
            vm.warp(time);
            vm.startPrank(ORACLE);
            basicNft.executeReaper();
            vm.stopPrank();
        }

        string memory basicUri = basicNft.tokenURI(tokenId);
        console2.log(basicUri);

    }
    
}