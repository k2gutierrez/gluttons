// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test, console2} from "forge-std/Test.sol";
import {Gluttons} from "../../src/Gluttons.sol";
import {DeployGluttons} from "../../script/DeployGluttons.s.sol";
import {GluttonsFood} from "../../src/GluttonsFood.sol";

contract GluttonsTest is Test {
    uint256 constant STARTING_BALANCE = 400 ether;
    uint256 public constant PET_PRICE = 100e18;
    uint256 private constant FOOD7_PRICE = 14e18;
    uint256 private constant FOOD30_PRICE = 30e18;
    uint256 private constant STARVATION_TIME = 12 hours;

    Gluttons public basicNft;
    GluttonsFood public foodNft;

    DeployGluttons deployer;

    address USER = makeAddr("user");
    address USER2 = makeAddr("user2");
    address DEV1 = makeAddr("dev1");
    address DEV2 = makeAddr("dev2");
    address ORACLE = makeAddr("oracle");
    address OWNER;

    function setUp() public {
        deployer = new DeployGluttons(DEV1, DEV2);
        (basicNft, foodNft, OWNER) = deployer.run();

        vm.deal(USER, STARTING_BALANCE);
        vm.deal(USER2, STARTING_BALANCE);
        vm.deal(ORACLE, STARTING_BALANCE);

        vm.prank(basicNft.owner());
        basicNft.setOracle(ORACLE);
    }

    // Helper functions
    function mintPet(address user, uint256 amount) internal {
        vm.prank(user);
        basicNft.mintPet{value: (PET_PRICE * amount)}(amount);
    }

    function buyFoodPackWeek(address user) internal {
        vm.prank(user);
        basicNft.buyFoodPackWeek{value: FOOD7_PRICE}(user);
    }

    function buyFoodPackMonth(address user) internal {
        vm.prank(user);
        basicNft.buyFoodPackMonth{value: FOOD30_PRICE}(user);
    }

    function feedPet(address _user, uint256 petId, uint256 foodTokenId) internal {
        // First get a food token ID to use
        vm.prank(_user);
        basicNft.feedPet(_user, petId, foodTokenId);
    }

    function executeReaper() internal {
        vm.prank(ORACLE);
        basicNft.executeReaper();
    }

    // Deployment Tests
    function testContractDeployment() public view {
        assertEq(basicNft.name(), "Gluttons");
        assertEq(basicNft.symbol(), "GLUTTONS");
        assertEq(basicNft.owner(), OWNER);
        assertEq(address(basicNft.getFoodContract()), address(foodNft));
    }

    // Minting Tests
    function testGluttonTokenIndex() public {
        uint256 mintAmount = 2;
        mintPet(USER, mintAmount);
        assertEq(basicNft.totalSupply(), mintAmount);
    }

    function testGluttonSingleMint() public {
        mintPet(USER, 1);
        assertEq(basicNft.balanceOf(USER), 1);
    }

    function testGluttonMultipleMint() public {
        mintPet(USER, 2);
        assertEq(basicNft.balanceOf(USER), 2);
    }

    function testMintFailsWhenGameEnded() public {
        vm.prank(basicNft.owner());
        basicNft.changeGameStatus();
        
        vm.prank(USER);
        vm.expectRevert(Gluttons.Gluttons__GameEnded.selector);
        basicNft.mintPet{value: PET_PRICE}(1);
    }

    function testMintFailsWithInsufficientEth() public {
        vm.prank(USER);
        vm.expectRevert(abi.encodeWithSelector(Gluttons.Gluttons__IncorrectEthAmount.selector, 0));
        basicNft.mintPet{value: 0}(1);
    }

    // Food Purchase Tests
    function testCannotBuyFoodPackWeekWithoutOwningPet() public {
        vm.prank(USER);
        vm.expectRevert();
        basicNft.buyFoodPackWeek{value: FOOD7_PRICE}(USER);
    }

    function testBuyFoodPackWeek() public {
        mintPet(USER, 1);
        buyFoodPackWeek(USER);
        assertEq(foodNft.balanceOf(USER), 7);
    }

    function testBuyFoodPackMonth() public {
        mintPet(USER, 1);
        buyFoodPackMonth(USER);
        assertEq(foodNft.balanceOf(USER), 30);
    }

    function testFoodPurchaseAddsToPrizePool() public {
        mintPet(USER, 1);
        uint256 initialPool = basicNft.getTotalPrizePool();
        
        buyFoodPackWeek(USER);
        assertEq(
            basicNft.getTotalPrizePool(),
            initialPool + (FOOD7_PRICE * 90) / 100
        );
    }

    // Feeding Tests
    function testFeedPet() public {
        
        mintPet(USER, 1);
        buyFoodPackWeek(USER);
        
        uint256 tokenId = 1;
        uint256 foodTokenId = 0;
        feedPet(USER, tokenId, foodTokenId);
        
        Gluttons.Pet memory token = basicNft.getPetInfo(tokenId);
        assertEq(token.alive, true);
        assertEq(token.fed, true);
    }

    function testFeedFailsWhenNotOwner() public {
        mintPet(USER, 1);
        buyFoodPackWeek(USER);
        uint256 tokenId = 1;
        
        vm.prank(USER2);
        vm.expectRevert(Gluttons.Gluttons__NotTheOwnerOfTheToken.selector);
        basicNft.feedPet(USER2, tokenId, 0);
    }

    // Reaper Execution Tests
    function testExecuteReaper() public {
        mintPet(USER, 3);
        uint256 tokenId = 1;
        
        // Fast forward to starvation time
        vm.warp(block.timestamp + STARVATION_TIME);
        
        executeReaper();
        
        Gluttons.Pet memory token = basicNft.getPetInfo(tokenId);
        assertEq(token.alive, false);
    }

    function testExecuteReaperFailsWhenTooEarly() public {
        mintPet(USER, 1);
        uint256 tokenId = 0;
        
        uint256[] memory starvedPets = new uint256[](1);
        starvedPets[0] = tokenId;

        vm.warp(block.timestamp + 11 hours);
        vm.prank(ORACLE);
        vm.expectRevert(Gluttons.Gluttons__TooEarly.selector);
        basicNft.executeReaper();
    }

    function testExecuteReaperEndsGameWhenNoSurvivors() public {
        mintPet(USER, 3);
        
        // Fast forward to starvation time
        vm.warp(block.timestamp + STARVATION_TIME);
        
        executeReaper();
        assertEq(basicNft.getGameActiveStatus(), false);
    }

    // Voting Tests
    function testCastVote() public {
        mintPet(USER, 1);
        uint256 token = 0;
        vm.prank(USER);
        basicNft.castVote(true, token);
        
        assertEq(basicNft.getTotalVotes(), basicNft.totalSupply());
        assertEq(basicNft.checkIdTokenHasVoted(token), true);
    }

    function testVoteEndsGameWithConsensus() public {
        mintPet(USER, 1);
        mintPet(USER2, 1);
        mintPet(ORACLE, 1);
        
        vm.prank(USER);
        basicNft.castVote(true, 0);
        vm.prank(USER2);
        basicNft.castVote(true, 1);
        vm.prank(ORACLE);
        basicNft.castVote(true, 2);
        assertEq(basicNft.getTotalVotes(), basicNft.totalSupply());
        assertEq(basicNft.getGameActiveStatus(), false);
    }

    function testVoteResetWhenNoConsensusAndReapercall() public {
        mintPet(USER, 1);
        buyFoodPackWeek(USER);
        mintPet(USER2, 1);
        buyFoodPackWeek(USER2);
        mintPet(ORACLE, 1);
        buyFoodPackWeek(ORACLE);
        feedPet(USER, 1, 0);
        feedPet(ORACLE, 3, 14);
        
        // USER votes
        vm.prank(USER);
        basicNft.castVote(true, 1);

        assertEq(basicNft.getTotalVotes(), 1);
        
        // Kill USER2's pet
        vm.warp(block.timestamp + STARVATION_TIME + 1);
        executeReaper();

        assertEq(basicNft.totalSupply(), 2);
        assertEq(basicNft.getTotalVotes(), 0);

        // Votes should reset
        vm.prank(USER);
        basicNft.castVote(true, 0);
        assertEq(basicNft.getTotalVotes(), 1);
    }

    // Prize Claiming Tests
    function testClaimPrizeAfterVote() public {
        mintPet(USER, 3);
        buyFoodPackWeek(USER);

        vm.startPrank(USER);
        basicNft.feedPet(USER, 1, 0);
        basicNft.feedPet(USER, 2, 1);
        basicNft.feedPet(USER, 3, 2);
        vm.stopPrank();

        vm.warp(block.timestamp + 12 hours);
        vm.prank(ORACLE);

        uint256 initialBalance = USER.balance;

        basicNft.executeReaper();

        // End game by vote
        vm.startPrank(USER);
        basicNft.castVote(true, 1);
        basicNft.castVote(true, 2);
        basicNft.castVote(true, 3);
        vm.stopPrank();
        
        
        uint256 prizePool = basicNft.getTotalPrizePool();

        console2.log("initial balance: ", (initialBalance)/1e18);
        console2.log("initital balance + prizepool: ", (initialBalance + prizePool)/1e18);
        console2.log("new balance: ", (USER.balance)/1e18);
        
        assertEq(USER.balance, initialBalance + prizePool);
    }

    function testClaimPrizeAfterExtinction() public {
        mintPet(USER, 3);
        uint256 initialBalance = (USER.balance) / 1e18;
        console2.log("Initial Balance: ", initialBalance); 
        uint256 prizePool = (basicNft.getTotalPrizePool()) / 1e18;
        console2.log("Prize pool: ", prizePool); 
        // End game by extinction
        vm.warp(block.timestamp + STARVATION_TIME);
        //address[] memory lastRecords = basicNft.getLasSurvivorsRecord().survivors;
        
        executeReaper();
        //console2.log("Records: ", lastRecords.length);
        uint256 updatedBalance = (USER.balance) / 1e18;
        console2.log("updated Balance: ", updatedBalance); 
        
        
        assertEq(updatedBalance, (initialBalance + prizePool));
    }

    // Admin Function Tests
    function testSetOracle() public {
        address newOracle = makeAddr("newOracle");
        vm.prank(basicNft.owner());
        basicNft.setOracle(newOracle);
        assertEq(basicNft.getOracle(), newOracle);
    }

    function testCannotSetFoodContract() public {
        address newFoodContract = makeAddr("newFoodContract");
        vm.prank(basicNft.owner());
        vm.expectRevert(Gluttons.Gluttons__FoodContractAddressAlreadySet.selector);
        basicNft.setFoodContract(newFoodContract);
    }

    function testWithdrawDevShare() public {
        // Mint to create dev share
        mintPet(USER, 1);
        
        uint256 devBalanceBefore = DEV1.balance;
        uint256 contractBalance = address(basicNft).balance;
        
        vm.prank(basicNft.owner());
        basicNft.withdrawDevShare();
        
        // Dev1 should get 50% of non-prize pool
        assertEq(DEV1.balance, devBalanceBefore + (contractBalance - basicNft.getTotalPrizePool()) / 2);
    }

    function testCannotVoteWithoutPet() public {
        vm.prank(USER);
        vm.expectRevert(Gluttons.Gluttons__NotASurvivor.selector);
        basicNft.castVote(true, 0);
    }

    function testCannotFeedDeadPet() public {
        mintPet(USER, 3);
        buyFoodPackWeek(USER);
        uint256 tokenId = 1;
        
        // Kill pet
        vm.warp(block.timestamp + STARVATION_TIME + 1);

        executeReaper();
        
        vm.prank(USER);
        vm.expectRevert();
        basicNft.feedPet(USER, tokenId, 0);
    }

    function testPrizeDistributionWithMultipleSurvivors() public {

        mintPet(USER, 2);
        mintPet(USER2, 1);
        buyFoodPackWeek(USER);
        buyFoodPackWeek(USER2);

        uint256 startingBalance = USER.balance;
        uint256 startingBalance2 = USER2.balance;
        uint256 prizePool = basicNft.getTotalPrizePool();
        uint256 share = prizePool / basicNft.getAlivePetCount();
        uint256 shareUser1 = share * 2;
        uint256 shareUser2 = share;
        
        // End game by vote
        vm.startPrank(USER);
        basicNft.castVote(true, 1);
        basicNft.castVote(true, 2);
        vm.stopPrank();
        vm.prank(USER2);
        basicNft.castVote(true, 3);

        uint256 userBalanceAfter = USER.balance;
        uint256 user2BalanceAfter = USER2.balance;

        console2.log("share: ", share / 1 ether);

        console2.log("starting balance 1: ", startingBalance / 1 ether);

        console2.log("user balance after 1: ", userBalanceAfter/ 1 ether);
        console2.log("starting balance 2: ", startingBalance2 / 1 ether);

        console2.log("user balance after 2: ", user2BalanceAfter/ 1 ether);

        
        assertEq(userBalanceAfter / 10e18, (startingBalance + shareUser1) / 10e18);
        assertEq(user2BalanceAfter / 10e18, (startingBalance2 + shareUser2) / 10e18);

    }

    function testGluttonTransferRoyalty() public {
        mintPet(USER, 1);
        uint256 startingContractBalance = basicNft.getTotalPrizePool();
        uint256 valueForTransfer = 1e18;
        vm.prank(USER);
        basicNft.transferFrom{value: valueForTransfer}(USER, USER2, 1);

        uint256 balanceTokenUser2 = basicNft.balanceOf(USER2);
        assertEq(balanceTokenUser2, 1);

        uint256 ContractBalance = basicNft.getTotalPrizePool();
        uint256 expectedBalance = ((valueForTransfer * 10) / 100) + startingContractBalance;
        assertEq(ContractBalance, expectedBalance);
    }

}