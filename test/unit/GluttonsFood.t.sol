// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test, console2} from "forge-std/Test.sol";
import {Gluttons} from "../../src/Gluttons.sol";
import {GluttonsFood} from "../../src/GluttonsFood.sol";
import {DeployGluttonsFood} from "../../script/DeployGluttonsFood.s.sol";

contract GluttonsFoodTest is Test {

    //string constant NAME = "Mingles";
    //string constant SYMBOL = "Mgls";
    //string constant URI = "ipfs://QmcoeRsFYeHzPD9Gx84aKD3tjLUKjvPEMSmoPs2GQmHR1t/";

    enum Stakeholders {
        HOLDERS,
        DEVS
    }

    uint256 constant STARTING_BALANCE = 400 ether;
    uint256 public constant PET_PRICE = 100e18;
    uint256 private constant FOOD7_PRICE = 14e18;
    // price for 30 ERC721A NFTs.
    uint256 private constant FOOD30_PRICE = 30e18;

    Gluttons basicNft;
    GluttonsFood foodNft;
    DeployGluttonsFood deployer;

    address USER = makeAddr("user");
    address USER2 = makeAddr("user2");
    address DEV1 = makeAddr("dev1");
    address DEV2 = makeAddr("dev2");

    function setUp() public {
        deployer = new DeployGluttonsFood(DEV1, DEV2);
        (foodNft, basicNft) = deployer.run();

        vm.deal(USER, STARTING_BALANCE);
        vm.deal(USER2, STARTING_BALANCE);

        vm.prank(USER);

        basicNft.mintPet{value: PET_PRICE}(1);

        vm.prank(USER2);

        basicNft.mintPet{value: PET_PRICE}(1);

    }

    modifier mint7Pack(address user) {
        vm.prank(user);
        foodNft.mintFoodPackWeek{value: FOOD7_PRICE}(user);
        _;
    }

    function testGluttonBalanceOfWithMintSetUp() public view {
        uint256 expectedMintNumber = 1;
        uint256 mintNumber = basicNft.balanceOf(USER);
        console2.log("Mint number", mintNumber);
        assertEq(mintNumber, expectedMintNumber);
    }

    function testWeekPurchaseFood() public {
        uint256 expectedMintNumber = 7;
        vm.prank(USER);
        foodNft.mintFoodPackWeek{value: FOOD7_PRICE}(USER);
        uint256 mintedfood = foodNft.balanceOf(USER);
        console2.log("Minted Food Amount: ", mintedfood);
        assertEq(mintedfood, expectedMintNumber);
    }

    function testMonthPurchaseFood() public {
        uint256 expectedMintNumber = 30;
        vm.prank(USER);
        foodNft.mintFoodPackMonth{value: FOOD30_PRICE}(USER);
        uint256 mintedfood = foodNft.balanceOf(USER);
        console2.log("Minted Food Amount: ", mintedfood);
        assertEq(mintedfood, expectedMintNumber);
    }

    function testCheckHoldersBalance() public mint7Pack(USER) {
        uint256 holdersBalance = foodNft.checkHoldersBalance();
        uint256 expectedBalance = (FOOD7_PRICE * 90) / 100;
        assertEq(holdersBalance, expectedBalance);
    }

    function testCheckDevsBalance() public mint7Pack(USER)  {
        uint256 mintPetValueForDev = ((PET_PRICE * 2) * 10) / 100;
        uint256 devsBalance = foodNft.checkDevsBalance() + mintPetValueForDev;
        uint256 expectedBalance = ((FOOD7_PRICE * 10) / 100) + mintPetValueForDev;
        uint256 dev1Balance = DEV1.balance;
        uint256 dev2Balance = DEV2.balance;
        assertEq(devsBalance, (dev1Balance + dev2Balance));
        assertEq(devsBalance, expectedBalance);
    }

    function testFeedGlutton() public mint7Pack(USER) {
        uint256 tokenId = 0;
        uint256 expectedValue = 6;
        vm.prank(USER);
        foodNft.feedGlutton(USER, tokenId);
        uint256 updatedMintedfood = foodNft.balanceOf(USER);
        assertEq(expectedValue, updatedMintedfood);
    }

    function testNftTransferNotAvailable() public mint7Pack(USER) mint7Pack(USER2) {

        bool tstatus = foodNft.checkTransferStatus();
        console2.log("transfer status", tstatus);

        vm.expectRevert(GluttonsFood.GluttonsFood__transferNotAllowed.selector);
        vm.prank(USER);
        foodNft.transferFrom(USER, USER2, 0);
    }

    function testNftTransferAvailable() public mint7Pack(USER) mint7Pack(USER2) {
        
        uint256 expectedFinalValueUser1 = 6;
        uint256 expectedFinalValueUser2 = 8;
        
        uint256 userNfts = foodNft.balanceOf(USER);
        uint256 user2Nfts = foodNft.balanceOf(USER2);
        vm.prank(foodNft.owner());
        foodNft.changeTransferStatus();

        bool tstatus = foodNft.checkTransferStatus();
        console2.log("transfer status", tstatus);

        vm.prank(USER);
        foodNft.transferFrom(USER, USER2, 0);
        uint256 newUserNfts = foodNft.balanceOf(USER);
        uint256 newUser2Nfts = foodNft.balanceOf(USER2);

        assertNotEq(userNfts, newUserNfts);
        assertNotEq(user2Nfts, newUser2Nfts);
        assertEq(expectedFinalValueUser1, newUserNfts);
        assertEq(expectedFinalValueUser2, newUser2Nfts);

    }

    function testGetGameContractAddress() public view {
        address gameContract = foodNft.getGluttonsGameContract();
        console2.log("GameContract: ", gameContract);
        assertEq(gameContract, address(basicNft));
   }

    function testCheckTransferStatus() public view {
        bool transferStatus = foodNft.checkTransferStatus();
        assertEq(transferStatus, false);
    }

    function testgetFoodPrice7Pack() public view {
        uint256 foodPrice7Pack = foodNft.getFoodPrice7Pack();
        console2.log("7pack food price: ", foodPrice7Pack);
        assertEq(FOOD7_PRICE, foodPrice7Pack);
    }

    function testgetFoodPrice30Pack() public view {
        uint256 foodPrice30Pack = foodNft.getFoodPrice30Pack();
        console2.log("30pack food price: ", foodPrice30Pack);
        assertEq(FOOD30_PRICE, foodPrice30Pack);
    }

    function testContractBalance() public mint7Pack(USER) {
        uint256 contractBalance = foodNft.contractBalance();
        uint256 currentBalance = 0;
        console2.log("Contract Balance: ",  contractBalance);
        console2.log("Current Balance: ",  currentBalance);
        assertEq(contractBalance, currentBalance);
    }

    function testTokenUri() public mint7Pack(USER) {
        string memory uri = foodNft.tokenURI(0);
        console2.log(uri);
    }

}