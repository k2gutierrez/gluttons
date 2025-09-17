// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test, console2} from "forge-std/Test.sol";
import {Gluttons} from "../../src/Gluttons.sol";
import {DeployGluttons} from "../../script/DeployGluttons.s.sol";
import {GluttonsFood} from "../../src/GluttonsFood.sol";

contract GluttonsBeforeTest is Test {

    //string constant NAME = "Mingles";
    //string constant SYMBOL = "Mgls";
    //string constant URI = "ipfs://QmcoeRsFYeHzPD9Gx84aKD3tjLUKjvPEMSmoPs2GQmHR1t/";

    address OWNER;

    uint256 constant STARTING_BALANCE = 400 ether;
    uint256 public constant PET_PRICE = 162e18;
    uint256 private constant FOOD7_PRICE = 14e18;
    uint256 private constant FOOD30_PRICE = 30e18;

    Gluttons basicNft;
    GluttonsFood foodNft;

    DeployGluttons deployer;

    address USER = makeAddr("user");
    address USER2 = makeAddr("user2");
    address DEV1 = makeAddr("dev1");
    address DEV2 = makeAddr("dev2");
    address Oracle = makeAddr("oracle");

    function setUp() public {
        deployer = new DeployGluttons();
        (basicNft, foodNft, OWNER) = deployer.run();

        vm.deal(USER, STARTING_BALANCE);

        vm.deal(USER2, STARTING_BALANCE);

        vm.prank(basicNft.owner());
        basicNft.setOracle(Oracle);

    }

    modifier mintPet(address _user){
        uint256 petMintAmount = 1;
        vm.prank(_user);
        basicNft.mintPet{value: (PET_PRICE * petMintAmount)}(petMintAmount);
        _;
    }

    function testGluttonTokenIndex() public {
        uint256 mintAmount = 2;
        vm.prank(USER);
        basicNft.mintPet{value: (PET_PRICE * mintAmount)}(mintAmount);
        uint256 counter = basicNft.totalSupply();
        assert(counter == mintAmount);
    }

    function testGluttonSingleMint() public {
        uint256 mintAmount = 1;
        vm.prank(USER);
        basicNft.mintPet{value: (PET_PRICE * mintAmount)}(mintAmount);
        uint256 counter = basicNft.balanceOf(USER);
        assertEq(counter, mintAmount);
    }

    function testGluttonMultipleMint() public {
        uint256 mintAmount = 2;
        vm.prank(USER);
        basicNft.mintPet{value: (PET_PRICE * mintAmount)}(mintAmount);
        uint256 counter = basicNft.balanceOf(USER);
        assert(counter == mintAmount);
    }

    function testUnableToChangeFoodContractAddress() public {
        address newFoodContract = makeAddr("newFoodContract");
        address foodContract = address(foodNft);
        console2.log("Food Contract", foodContract);
        
        vm.prank(basicNft.owner());
        vm.expectRevert();
        basicNft.setFoodContract(newFoodContract);
    }

    function testCannotBuyFoodPackWeekFromGluttonContractIfNotAHolder() public {
        vm.prank(USER);
        vm.expectRevert();
        basicNft.buyFoodPackWeek{value: FOOD7_PRICE}(USER);
    }

    function testBuyFoodPackWeekFromGluttonContract() public mintPet(USER) {
        uint256 expectedMintFoodAmount = 7;
        vm.prank(USER);
        basicNft.buyFoodPackWeek{value: FOOD30_PRICE}(USER);
        
        uint256 foodMintAmount = foodNft.balanceOf(USER);
        assertEq(expectedMintFoodAmount, foodMintAmount);
    }

    function testBuyFoodPackMonthFromGluttonContract() public mintPet(USER) {
        uint256 expectedMintFoodAmount = 30;
        vm.prank(USER);
        basicNft.buyFoodPackMonth{value: FOOD30_PRICE}(USER);
        
        uint256 userBalanceA = address(USER).balance;
        uint256 userBalanceB = STARTING_BALANCE - PET_PRICE - FOOD30_PRICE;

        uint256 gluttonContractA = address(basicNft).balance;
        uint256 gluttonContractB = basicNft.getTotalPrizePool();

        uint256 foodMintAmount = foodNft.balanceOf(USER);
        assertEq(userBalanceA, userBalanceB);
        assertEq(gluttonContractA, gluttonContractB);
        assertEq(expectedMintFoodAmount, foodMintAmount);
    }

}