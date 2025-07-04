// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {ERC721A} from "@ERC721A/contracts/ERC721A.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import {GluttonsFood} from "./GluttonsFood.sol";

/**
 * @title Gluttons
 * @author NFT Gamefied expierence to feed a Glutton daily, all the money 
 * except 10% goes to a pool, last man standing get the pool or if a vote
 * is made the pool can be divided to the last survivors.
 * @author Carlos Enrique Gutiérrez Chimal
 * @author Github - k2gutierrez
 * @author X - CarlosDappsDev.eth
 * @author 0xca067E20db2cDEF80D1c7130e5B71C42c0305529
 */
contract Gluttons is ERC721A, Ownable, ReentrancyGuard {

    /* CUSTOM ERRORS */
    error Gluttons__GameEnded();
    error Gluttons__IncorrectEthAmount(uint256 amount);
    error Gluttons__MaxSupplyReachedOrAmountExceeds();
    error Gluttons__NotTheOwnerOfTheToken();
    error Gluttons__PetIsDead();
    error Gluttons__FeedingFailed();
    error Gluttons__FoodPurchaseFailed();
    error Gluttons__WithdrawTransferFailed();
    error Gluttons__FoodContractAddressAlreadySet();
    error Gluttons__GameStillActive();
    error Gluttons__NotASurvivor();
    error Gluttons__AlreadyVoted();
    error Gluttons__TooEarly();
    error Gluttons__NoSurvivors();
    error Gluttons__NotInLastSurvivorsSet();
    error Gluttons__NotOracleCalling();
    error Gluttons__ZeroValueToTransfer();

    // Game state - Used to check if the glutton is alive
    struct Pet {
        bool fed;
        bool alive;
    }
    
    // List of addresses of the owners of the alive Gluttons
    struct SurvivorRecord {
        address[] survivors;
        uint256 timestamp;
    }
    
    // Game parameters
    uint256 public constant PET_PRICE = 162e18;
    uint256 public constant STARVATION_TIME = 1 days;
    uint256 public constant MAX_PETS = 1500;

    // price for 7 ERC721A NFTs.
    uint256 private constant FOOD7_PRICE = 7e18;
    // price for 30 ERC721A NFTs.
    uint256 private constant FOOD30_PRICE = 15e18;

    // Dev addresses
    address private immutable i_dev1;
    address private immutable i_dev2;
    
    // External food contract
    address public s_foodContract;
    
    // Game state
    mapping(uint256 => Pet) public s_pets;
    uint256 private s_totalPrizePool;
    uint256 public s_lastReaperCall;
    bool public s_gameActive = true;
    SurvivorRecord public s_lastSurvivors;  
    
    // Voting state
    mapping(uint256 => bool) public s_hasVoted;
    uint256 public s_totalVotes;
    uint256 public s_lastVoteResetBlock;

    // Oracles address to activate the reapercall
    address public s_oracle;
    
    /* EVENTS */
    event Fed(uint256 indexed petId);
    event Starved(uint256 indexed petId);
    event Dead(uint256 indexed petId);
    event PrizeClaimed(address indexed winner, uint256 amount);
    event GameEndedByVote();
    event GameEndedByExtinction();
    event VoteReset();
    event SurvivorRecordUpdated();

    /* MODIFIERS */
    // Checks if the msg.sender is the owner of the Token
    modifier tokenOwner(uint256 tokenId) {
        if (ownerOf(tokenId) != msg.sender){
            revert Gluttons__NotTheOwnerOfTheToken();
        }
        _;
    }

    constructor(address _dev1, address _dev2) 
        ERC721A("Gluttons", "GLUTTONS") 
        Ownable(msg.sender)
    {
        s_lastSurvivors = SurvivorRecord(new address[](0), block.timestamp);
        i_dev1 = _dev1;
        i_dev2 = _dev2;
    }

    receive() external payable{
        // Accept ETH transfers without reverting
    }
    
    /**
     * function used to mint NFTs
     * @param _amount Amount of NFTs the msg.sender wants to purchase.
     */
    function mintPet(uint256 _amount) external payable nonReentrant {
        if (!s_gameActive) revert Gluttons__GameEnded();
        if (msg.value < (PET_PRICE * _amount)) revert Gluttons__IncorrectEthAmount(msg.value);
        if (_totalMinted() + _amount > MAX_PETS) revert Gluttons__MaxSupplyReachedOrAmountExceeds();
        
        uint256 currentIndexToken = _nextTokenId();
        _mint(msg.sender, _amount);
        
        for (uint256 i; i < _amount; i ++){
            s_pets[currentIndexToken] = Pet(false, true); // Gluttons starts without being fed
            currentIndexToken ++;
        }
        
        _updateSurvivorRecord();

        uint256 poolAmount = (msg.value * 90) / 100;
        uint256 devAmount = msg.value - poolAmount;
        uint256 dev1Amount = (devAmount * 50) / 100;
        uint256 dev2Amount = devAmount - dev1Amount;
        _safeTransferETH(i_dev1, dev1Amount);
        _safeTransferETH(i_dev2, dev2Amount);
        
        // Add to prize pool (90% of mint price)
        s_totalPrizePool += poolAmount;
    }

    /**
     * Function used to purchase GluttonsFood which is another NFTs contract, 
     * You need to be a Gluttons holder to be able to purchase Food.
     * The amount is set for 7 NFTs
     */
    function buyFoodPackWeek(address _user) external payable nonReentrant {
        if (!s_gameActive) revert Gluttons__GameEnded();
        if (msg.value < FOOD7_PRICE) revert Gluttons__IncorrectEthAmount(msg.value);

        bool success = GluttonsFood(s_foodContract).mintFoodPackWeek{value: msg.value}(_user);
        /*(bool success, ) = s_foodContract.call{value: FOOD7_PRICE}(
            abi.encodeWithSignature("mintFoodPackWeek(address)", _user)
        );*/
        if (!success) revert Gluttons__FoodPurchaseFailed();
        
        // Add to prize pool (90% of food price)
        s_totalPrizePool += (msg.value * 90) / 100;
    }

    /**
     * Function used to purchase GluttonsFood which is another NFTs contract, 
     * You need to be a Gluttons holder to be able to purchase Food.
     * The amount is set for 30 NFTs
     */
    function buyFoodPackMonth(address _user) external payable nonReentrant {
        if (!s_gameActive) revert Gluttons__GameEnded();
        if (msg.value < FOOD30_PRICE) revert Gluttons__IncorrectEthAmount(msg.value);
        bool success = GluttonsFood(s_foodContract).mintFoodPackMonth{value: msg.value}(_user);
        /*(bool success, ) = s_foodContract.call{value: FOOD30_PRICE}(
            abi.encodeWithSignature("mintFoodPackMonth(address)", _user)
        );*/
        if (!success) revert Gluttons__FoodPurchaseFailed();
        
        // Add to prize pool (90% of food price)
        s_totalPrizePool += (msg.value * 90) / 100;
    }
    
    /**
     * Feeding mechanism
     * @param petId The Gluttons TokenId the msg.sender holds - NFT that will be fed
     * @param foodId The GluttonsFood NFT tokenId which will be spent to feed the Glutton
     */
    function feedPet(address _user, uint256 petId, uint256 foodId) external tokenOwner(petId) nonReentrant {
        if (s_pets[petId].alive == false) revert Gluttons__PetIsDead();

        bool success = GluttonsFood(s_foodContract).feedGlutton(_user, foodId);
        
        /*(bool success, ) = s_foodContract.call(
            abi.encodeWithSignature("feedGlutton(address, uint256)", _user, foodId)
        );*/
        if (!success) revert Gluttons__FeedingFailed();
        
        s_pets[petId].fed = true;
        emit Fed(petId);
    }
    
    /**
     * Oracle execution (called by off-chain executor)
     * Function to be executed by an oracle, checks for starved Gluttons and burns them "_burn" each starved NFT
     */
    function executeReaper() external {
        if (!s_gameActive) revert Gluttons__GameEnded();
        if (msg.sender != _getOracle()) revert Gluttons__NotOracleCalling();
        if (block.timestamp < s_lastReaperCall + STARVATION_TIME) revert Gluttons__TooEarly();
        ///// check this requirement as above require(block.timestamp >= lastReaperCall + 23 hours, "Too early");
        
        // Update survivor record before processing deaths
        _updateSurvivorRecord();
        
        // Process starved pets
        for(uint256 i = 0; i < MAX_PETS; i++) {
            if(s_pets[i].alive && s_pets[i].fed == false) {
                _burnPet(i);
            } else if (s_pets[i].alive && s_pets[i].fed == true){
                // Reset votes for next round
                s_hasVoted[i] = false;
            }
        }
        
        s_lastReaperCall = block.timestamp;
        s_totalVotes = 0;
        
        // Check for extinction scenario
        if (getAlivePetCount() == 0) {
            s_gameActive = false;
            emit GameEndedByExtinction();
        }
    }
    
    /**
     * Voting mechanism (100% consensus required)
     * @param voteToEnd The voting choice of each alive Glutton holder
     */
    function castVote(bool voteToEnd, uint256 tokenId) external {
        if (!s_gameActive) revert Gluttons__GameEnded();
        if (balanceOf(msg.sender) == 0) revert Gluttons__NotASurvivor();
        if (s_hasVoted[tokenId]) revert Gluttons__AlreadyVoted();
        
        s_hasVoted[tokenId] = true;
        if (voteToEnd) s_totalVotes++;
        
        // Check for 100% consensus
        if (s_totalVotes == getAlivePetCount() && s_totalVotes > 0) {
            s_gameActive = false;
            emit GameEndedByVote();
        }
    }
    
    /**
     * Prize claiming - Function to claim eth (ape) back form the pool after certain 
     * conditions have been set
     */
    function claimPrize() external nonReentrant {
        if (s_gameActive) revert Gluttons__GameStillActive();
        
        uint256 share = 0;
        
        if (getAlivePetCount() > 0) {
            // Game ended by vote - split among survivors
            share = s_totalPrizePool / getAlivePetCount();
            if (balanceOf(msg.sender) <= 0) revert Gluttons__NotASurvivor();
            //require(balanceOf(msg.sender) > 0, "Not a survivor");
        } else {
            // Game ended by extinction - split among last survivors
            if (s_lastSurvivors.survivors.length == 0) revert Gluttons__NoSurvivors();
            //require(lastSurvivors.survivors.length > 0, "No survivor record");
            share = s_totalPrizePool / s_lastSurvivors.survivors.length;
            if (!_wasLastSurvivor(msg.sender)) revert Gluttons__NotInLastSurvivorsSet();
            //require(_wasLastSurvivor(msg.sender), "Not in last survivor set");
        }
        
        // Prevent reentrancy
        //s_totalPrizePool -= share; this generates that after each claim, everyone claims less
        payable(msg.sender).transfer(share);
        emit PrizeClaimed(msg.sender, share);
    }

    // Admin functions (only for setup)
    /**
     * Function to withdraw shares for the devs, only for safetyMethod in case extra eth come into contract
     */
    function withdrawDevShare() external onlyOwner {
        uint256 balance = address(this).balance - s_totalPrizePool;
        uint256 dev1Balance = (balance * 50) / 100;
        uint256 dev2Balance = balance - dev1Balance;
        (bool dev1Success, ) = payable(i_dev1).call{value: dev1Balance}(""); //transfer(dev1Balance);
        (bool dev2Success, ) = payable(i_dev2).call{value: dev2Balance}(""); //transfer(dev2Balance);

        if (!dev1Success || !dev2Success) {
            revert Gluttons__WithdrawTransferFailed();
        }

    }

    /**
     * Sets the oracle address that will execute the burn function
     * @param _oracle oracle address that will make the call of "executeReaper"
     */
    function setOracle(address _oracle) external onlyOwner {
        s_oracle = _oracle;
    }

    /**
     * Used by owner to force stop the game active status
     */
    function changeGameStatus() external onlyOwner {
        s_gameActive = !s_gameActive;
    }

    /**
     * Food Contract CONFIGURATION. Can only be set once
     */
    function setFoodContract(address _foodContract) external onlyOwner {
        if (s_foodContract != address(0)) revert Gluttons__FoodContractAddressAlreadySet();
        s_foodContract = _foodContract;
    }

    /**
     * Hook provided in the ERC721A to add the soulbound function to prevent or not transfer functions.
     * @param from used to check if it is address(0) to prevent 10% msg.value to go to the pool.
     * @param to used to check if it is address(0) to prevent 10% msg.value to go to the pool.
     * @param startTokenId not used in this override.
     * @param quantity not used in this override.
     */
    function _beforeTokenTransfers(
        address from,
        address to,
        uint256 startTokenId,
        uint256 quantity
    ) internal virtual override {
        if (from != address(0) && to != address(0)) {
            if (msg.value != 0) {
                uint256 royalty = (msg.value * 10) / 100;
                (bool success, ) = address(this).call{value: royalty}("");
                if (!success) revert Gluttons__WithdrawTransferFailed();
                s_totalPrizePool += royalty;
            }
        }
    }
    
    /**
     * Safety mechanism for extinction scenario. Records the last survivorRecords
     */
    function _updateSurvivorRecord() private {
        uint256 survivorCount = getAlivePetCount();
        
        if (survivorCount > 0) {
            // Clear previous record
            delete s_lastSurvivors.survivors;
            
            // Simplified tracking - in production use Merkle proofs or L2
            for (uint256 i = 0; i < MAX_PETS; i++) {
                if (_exists(i) && s_pets[i].alive) {
                    s_lastSurvivors.survivors.push(ownerOf(i));
                }
            }
            
            s_lastSurvivors.timestamp = block.timestamp;
            emit SurvivorRecordUpdated();
        }
    }

    /**
     * Burn function for the "executeReaper" function
     */
    function _burnPet(uint256 petId) private {
        s_pets[petId].alive = false;
        _burn(petId);
        emit Starved(petId);
        
        // Reset votes for next round
        s_hasVoted[petId] = false;
    }

    /**
     * Add fail-safe for ETH transfers
     * @param to address to send eth
     * @param value eth sent to the "to" address
     */
    function _safeTransferETH(address to, uint256 value) private {
        if (value == 0) revert Gluttons__ZeroValueToTransfer();
        (bool success, ) = to.call{value: value}("");
        if (!success) revert Gluttons__WithdrawTransferFailed();
    }

    /**
     * User to set the first token id as 1.
     */
    function _startTokenId() internal view virtual override returns (uint256) {
        return 1;
    }
    
    /**
     * Checks if you were a last survivor
     */
    function _wasLastSurvivor(address claimant) private view returns (bool) {
        for (uint i = 0; i < s_lastSurvivors.survivors.length; i++) {
            if (s_lastSurvivors.survivors[i] == claimant) return true;
        }
        return false;
    }

    /**
     * Get Oracle address
     */
    function _getOracle() private view returns(address){
        return s_oracle;
    }

    /**
     * Gets the amount of alive pets
     */
    function getAlivePetCount() public view returns (uint256) {
        uint256 count = 0;
        for(uint256 i = 0; i < MAX_PETS; i++) {
            if(_exists(i) && s_pets[i].alive) count++;
        }
        return count;
    }

    /**
     * Get the amount of s_totalPrizePool
     */
    function getTotalPrizePool() public view returns(uint256) {
        return s_totalPrizePool;
    }

    /**
     * Get the balance of the Gluttons contract
     */
    function getGluttonsContractBalance() public view returns(uint256) {
        return address(this).balance;
    }

}