// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {ERC721A} from "@ERC721A/contracts/ERC721A.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";
import {GluttonsFood} from "./GluttonsFood.sol";
import {GluttonEggs} from "./GluttonEggs.sol";
import {GluttonsBGBody} from "./GluttonsBGBody.sol";
import {GluttonsPattern} from "./GluttonsPattern.sol";
import {GluttonsMouth} from "./GluttonsMouth.sol";
import {GluttonsRightEye} from "./GluttonsRightEye.sol";
import {GluttonsLeftEye} from "./GluttonsLeftEye.sol";

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
contract Gluttons is
    ERC721A,
    Ownable,
    ReentrancyGuard,
    GluttonEggs,
    GluttonsBGBody,
    GluttonsPattern,
    GluttonsMouth,
    GluttonsRightEye,
    GluttonsLeftEye
{
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
    error Gluttons__PetAlreadyFed();
    error Gluttons__TraitsAlreadyLocked();
    error Gluttons__AlreadyClaimedPrice();
    error Gluttons__AddressAlreadyClaimed();
    error Gluttons__ThereAreSurvivors();
    error Gluttons__InsuficientBalanceInContract();
    error Gluttons__ThereAreMoreOrNoSurvivors();
    error Gluttons__MintedAmountNotReached();

    // Game state - Used to check if the glutton is alive
    struct Pet {
        bool fed;
        bool alive;
        uint256 timesFed;
        bool claim;
    }

    // Struct of traits for the on-chain NFT
    struct GluttonTraits {
        uint256 Body;
        uint256 Pattern;
        uint256 Mouth;
        uint256 LeftEye;
        uint256 RightEye;
    }

    // List of addresses of the owners of the alive Gluttons
    struct SurvivorRecord {
        address[] survivors;
        uint256 timestamp;
    }

    // Used to check if the user has claimed his price
    //mapping(address winner => bool claimed) private s_addressClaimed;

    // Traits variables
    mapping(uint256 => GluttonTraits) private s_tokenTraits;
    
    // Used to see if the traits are locked or not
    bool private s_traitsLocked = false;

    // Game parameters
    /// Pet price
    uint256 private constant PET_PRICE = 100e18;
    /// time for starvation, for reapercall
    uint256 private constant STARVATION_TIME = 12 hours;//1 days;
    /// maximum amount of pets that can be minted
    uint256 private constant MAX_PETS = 1000;
    /// Reaper checks if there is a winner or extinction if certain amount of nfts have been minted
    uint256 private constant MIN_MINTED_TO_CHECK_WINNER = 3;

    // price for 7 ERC721A NFTs.
    //uint256 private constant FOOD7_PRICE = 14e18;
    // price for 30 ERC721A NFTs.
    //uint256 private constant FOOD30_PRICE = 30e18;

    // Dev addresses
    address private immutable i_dev1;
    address private immutable i_dev2;

    // External food contract
    address private s_foodContract;

    // Oracles address to activate the reapercall
    address private s_oracle;

    // Game state
    mapping(uint256 => Pet) private s_pets;
    uint256 private s_totalPrizePool;
    uint256 private s_lastReaperCall;
    bool private s_gameActive = true;
    SurvivorRecord private s_lastSurvivors;

    // Voting state
    mapping(uint256 => bool) private s_hasVoted;
    uint256 private s_totalVotes;
    //uint256 public s_lastVoteResetBlock;

    

    /* EVENTS */
    event Fed(uint256 indexed petId);
    event Starved(uint256 indexed petId);
    event Dead(uint256 indexed petId);
    event PrizeClaimed(address indexed winner, uint256 amount);
    event GameEndedBySingleSurvivor(address users);
    event GameEndedByVote(uint256 amountUsers);
    event GameEndedByExtinction(uint256 amountUsers);
    event VoteReset();
    event SurvivorRecordUpdated();

    /* MODIFIERS */
    // Checks if the msg.sender is the owner of the Token
    modifier tokenOwner(uint256 tokenId) {
        if (ownerOf(tokenId) != msg.sender) {
            revert Gluttons__NotTheOwnerOfTheToken();
        }
        _;
    }

    constructor(address _dev1, address _dev2) ERC721A("Gluttons", "GLUTTONS") Ownable(msg.sender) {
        s_lastSurvivors = SurvivorRecord(new address[](0), block.timestamp);
        i_dev1 = _dev1;
        i_dev2 = _dev2;
    }

    receive() external payable {
        // Accept ETH transfers without reverting
    }

    //function checkClaimeAddressStatus() public view returns (bool) {
    //    return s_addressClaimed[msg.sender];
    //}

    function setlockTraits() external onlyOwner {
        s_traitsLocked = !s_traitsLocked;
    }

    function setTokenTraits(uint256 tokenId, uint256[5] calldata traits) external onlyOwner {
        if (s_traitsLocked) revert Gluttons__TraitsAlreadyLocked();

        s_tokenTraits[tokenId].Body = traits[0];
        s_tokenTraits[tokenId].Pattern = traits[1];
        s_tokenTraits[tokenId].Mouth = traits[2];
        s_tokenTraits[tokenId].LeftEye = traits[3];
        s_tokenTraits[tokenId].RightEye = traits[4];
    }

    function setTokenTraitsAll(uint256 tokenId, uint256[5][] calldata traits) external onlyOwner {
        if (s_traitsLocked) revert Gluttons__TraitsAlreadyLocked();

        for (uint256 j = 0; j < tokenId; j++) {
            uint256 token = j+1;
            for (uint256 i = 0; i < traits.length; i++) {
                
                s_tokenTraits[token].Body = traits[i][0];
                s_tokenTraits[token].Pattern = traits[i][1];
                s_tokenTraits[token].Mouth = traits[i][2];
                s_tokenTraits[token].LeftEye = traits[i][3];
                s_tokenTraits[token].RightEye = traits[i][4];
            }
        }
    }

    function _generateSVG(uint256 tokenId) private view returns (string memory) {
        GluttonTraits memory traits = s_tokenTraits[tokenId];
        string[4] memory body = _GluttonsBodyArr();
        string[4] memory pattern = _GluttonsPatternArr();
        string[39] memory mouth = _GluttonsMouthArr();
        string[36] memory leftEye = _GluttonsLeftEyeArr();
        string[36] memory rightEye = _GluttonsRightEyeArr();

        // Use abi.encodePacked for gas efficiency
        return string(
            abi.encodePacked(
                '<svg data-name="Layer 2" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 2048.06 2048.2" preserveAspectRatio="xMidYMid meet">',
                '<image x="0" y="0" width="2048" height="2048" href="',
                _GluttonsBackground(),
                '" />' '<image x="0" y="0" width="2048" height="2048" href="',
                body[traits.Body],
                '"/>' '<image x="0" y="0" width="2048" height="2048" href="',
                pattern[traits.Pattern],
                '"/>' '<image x="0" y="0" width="2048" height="2048" href="',
                mouth[traits.Mouth],
                '"/>' '<image x="0" y="0" width="2048" height="2048" href="',
                leftEye[traits.LeftEye],
                '"/>' '<image x="0" y="0" width="2048" height="2048" href="',
                rightEye[traits.RightEye],
                '"/>' "</svg>"
            )
        );
    }

    function _traitAttribute(string memory traitType, string memory value) internal pure returns (string memory) {
        return string(abi.encodePacked('{"trait_type": "', traitType, '",', '"value": "', value, '"}'));
    }

    function _unHatchedEggURI(uint256 _tokenId, string memory _egg, uint256 _timesFed) private pure returns(string memory) {
        string memory json1 = Base64.encode(
                bytes(
                    string(
                        abi.encodePacked(
                            '{"name": "Glutton Unhatched #',
                            _toString(_tokenId),
                            '",',
                            '"description": "On-chain Glutton ready to be fed in order to hatch",',
                            '"image": "',
                            _egg,
                            '",',
                            '"attributes": [',
                            _traitAttribute("Unhatched, times fed", _toString(_timesFed)),
                            ",",
                            "]",
                            "}"
                        )
                    )
                )
            );

            return string(abi.encodePacked("data:application/json;base64,", json1));
    }

    function _hatchedEggURI(uint256 _tokenId, string memory _egg, uint256 _timesFed) private pure returns(string memory) {
        string memory json2 = Base64.encode(
                bytes(
                    string(
                        abi.encodePacked(
                            '{"name": "Hatched #',
                            _toString(_tokenId),
                            '",',
                            '"description": "On-chain Glutton ready to be fed in order to hatch",',
                            '"image": "',
                            _egg,
                            '",',
                            '"attributes": [',
                            _traitAttribute("Hatched, times fed: ", _toString(_timesFed)),
                            ",",
                            "]",
                            "}"
                        )
                    )
                )
            );

            return string(abi.encodePacked("data:application/json;base64,", json2));
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        if (!_exists(tokenId)) revert URIQueryForNonexistentToken();

        GluttonTraits memory traits = s_tokenTraits[tokenId];
        Pet memory glutton = s_pets[tokenId];
        uint256 hatch = 7;
        uint256 petHatch = 14;
        string memory egg;

        if (glutton.timesFed < hatch) {
            if (traits.Body == 0) {
                egg = _getUnhatchedEggs()[0];
            } else if (traits.Body == 1) {
                egg = _getUnhatchedEggs()[1];
            } else if (traits.Body == 2) {
                egg = _getUnhatchedEggs()[2];
            } else {
                egg = _getUnhatchedEggs()[3];
            }

            return _unHatchedEggURI(tokenId, egg, glutton.timesFed);
            /*string memory json1 = Base64.encode(
                bytes(
                    string(
                        abi.encodePacked(
                            '{"name": "Glutton Unhatched #',
                            _toString(tokenId),
                            '",',
                            '"description": "On-chain Glutton ready to be fed in order to hatch",',
                            '"image": "',
                            egg,
                            '",',
                            '"attributes": [',
                            _traitAttribute("Unhatched, times fed", _toString(glutton.timesFed)),
                            ",",
                            "]",
                            "}"
                        )
                    )
                )
            );

            return string(abi.encodePacked("data:application/json;base64,", json1));*/
        } else if (glutton.timesFed >= hatch && glutton.timesFed < petHatch) {
            if (traits.Body == 0) {
                egg = _getHatchedEggs()[0];
            } else if (traits.Body == 1) {
                egg = _getHatchedEggs()[1];
            } else if (traits.Body == 2) {
                egg = _getHatchedEggs()[2];
            } else {
                egg = _getHatchedEggs()[3];
            }

            return _hatchedEggURI(tokenId, egg, glutton.timesFed);

            /*string memory json2 = Base64.encode(
                bytes(
                    string(
                        abi.encodePacked(
                            '{"name": "Hatched #',
                            _toString(tokenId),
                            '",',
                            '"description": "On-chain Glutton ready to be fed in order to hatch",',
                            '"image": "',
                            egg,
                            '",',
                            '"attributes": [',
                            _traitAttribute("Hatched, times fed: ", _toString(glutton.timesFed)),
                            ",",
                            "]",
                            "}"
                        )
                    )
                )
            );

            return string(abi.encodePacked("data:application/json;base64,", json2));*/
        } else {
            string memory svgImage = _generateSVG(tokenId);
            string memory image = string(abi.encodePacked("data:image/svg+xml;base64,", Base64.encode(bytes(svgImage))));

            // Build metadata
            return _gluttonAlreadyHatchedURI(tokenId, image, traits.Body, traits.Pattern, traits.Mouth, traits.LeftEye, traits.RightEye);
            /*string memory json = Base64.encode(
                bytes(
                    string(
                        abi.encodePacked(
                            '{"name": "Glutton #',
                            _toString(tokenId),
                            '",',
                            '"description": "On-chain Glutton ready to be fed",',
                            '"image": "',
                            image,
                            '",',
                            '"attributes": [',
                            _traitAttribute("Body", _GluttonsBodyArr1()[traits.Body]),
                            ",",
                            _traitAttribute("Pattern", _GluttonsPatternArr1()[traits.Pattern]),
                            ",",
                            _traitAttribute("Mouth", _GluttonsMouthArr1()[traits.Mouth]),
                            ",",
                            _traitAttribute("Left eye", _GluttonsLeftEyeArr1()[traits.LeftEye]),
                            ",",
                            _traitAttribute("Right eye", _GluttonsRightEyeArr1()[traits.RightEye]),
                            "]",
                            "}"
                        )
                    )
                )
            );

            return string(abi.encodePacked("data:application/json;base64,", json));*/
        }
    }

    function _gluttonAlreadyHatchedURI(uint256 _tokenId, string memory _image, uint256 _body, uint256 _pattern, uint256 _mouth, uint256 _leftEye, uint256 _rightEye) private pure returns (string memory) {
        string memory json = Base64.encode(
                bytes(
                    string(
                        abi.encodePacked(
                            '{"name": "Glutton #',
                            _toString(_tokenId),
                            '",',
                            '"description": "On-chain Glutton ready to be fed",',
                            '"image": "',
                            _image,
                            '",',
                            '"attributes": [',
                            _traitAttribute("Body", _GluttonsBodyArr1()[_body]),
                            ",",
                            _traitAttribute("Pattern", _GluttonsPatternArr1()[_pattern]),
                            ",",
                            _traitAttribute("Mouth", _GluttonsMouthArr1()[_mouth]),
                            ",",
                            _traitAttribute("Left eye", _GluttonsLeftEyeArr1()[_leftEye]),
                            ",",
                            _traitAttribute("Right eye", _GluttonsRightEyeArr1()[_rightEye]),
                            "]",
                            "}"
                        )
                    )
                )
            );

            return string(abi.encodePacked("data:application/json;base64,", json));
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

        for (uint256 i; i < _amount; i++) {
            s_pets[currentIndexToken] = Pet(false, true, 0, false); // Gluttons starts without being fed
            currentIndexToken++;
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
        if (msg.value < GluttonsFood(getFoodContract()).getFoodPrice7Pack()) revert Gluttons__IncorrectEthAmount(msg.value);

        bool success = GluttonsFood(getFoodContract()).mintFoodPackWeek{value: msg.value}(_user);
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
        if (msg.value < GluttonsFood(getFoodContract()).getFoodPrice30Pack()) revert Gluttons__IncorrectEthAmount(msg.value);
        bool success = GluttonsFood(getFoodContract()).mintFoodPackMonth{value: msg.value}(_user);
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
        if (s_pets[petId].fed == true) revert Gluttons__PetAlreadyFed();

        bool success = GluttonsFood(s_foodContract).feedGlutton(_user, foodId);

        /*(bool success, ) = s_foodContract.call(
            abi.encodeWithSignature("feedGlutton(address, uint256)", _user, foodId)
        );*/
        if (!success) revert Gluttons__FeedingFailed();

        s_pets[petId].timesFed++;
        s_pets[petId].fed = true;
        emit Fed(petId);
    }

    /**
     * Oracle execution (called by off-chain executor)
     * Function to be executed by an oracle, checks for starved Gluttons and burns them "_burn" each starved NFT
     */
    function executeReaper() external {
        if (!s_gameActive) revert Gluttons__GameEnded();
        if (msg.sender != getOracle()) revert Gluttons__NotOracleCalling();
        if (block.timestamp < (s_lastReaperCall + STARVATION_TIME)) revert Gluttons__TooEarly();
        ///// check this requirement as above require(block.timestamp >= lastReaperCall + 23 hours, "Too early");
        if (_totalMinted() < MIN_MINTED_TO_CHECK_WINNER) revert Gluttons__MintedAmountNotReached();

        // Update survivor record before processing deaths
        _updateSurvivorRecord();

        // Process starved pets
        for (uint256 i = 0; i < MAX_PETS; i++) {
            if (s_pets[i].alive && s_pets[i].fed == false) {
                _burnPet(i);
            } else if (s_pets[i].alive && s_pets[i].fed == true) {
                // Reset votes for next round
                s_hasVoted[i] = false;
                s_pets[i].fed = false;
            }
        }

        s_lastReaperCall = block.timestamp;
        s_totalVotes = 0;

        // Check for extinction scenario
        if (getAlivePetCount() == 0) {
            _PrizeForExtinction();
        }

        if (getAlivePetCount() == 1) {
            _PrizeForSingleWinner();
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
        if (s_totalVotes == getAlivePetCount() && s_totalVotes > 1) {
            _PrizeForVoteWinners();
        }
    }

    /**
     * Prize given for extinction - used to send the money to the survivors before extinction
     */
    function _PrizeForExtinction() private nonReentrant {
        if (getAlivePetCount() != 0) revert Gluttons__ThereAreSurvivors();
        
        uint256 totalPrizePool = s_totalPrizePool;
        address[] memory survivors = _getLasSurvivorsRecordArray();
        uint256 share = totalPrizePool / survivors.length;

        if (address(this).balance < totalPrizePool) revert Gluttons__InsuficientBalanceInContract();

        for (uint256 i = 0; i < survivors.length; i++) {
            _safeTransferETH(survivors[i], share);
            emit PrizeClaimed(survivors[i], share);
        }

        s_gameActive = false;
        emit GameEndedByExtinction(survivors.length);

    }

    /**
     * Prize given for single winner - used to send the money to the only survivor left
     */
    function _PrizeForSingleWinner() private nonReentrant {
        if (getAlivePetCount() != 1) revert Gluttons__ThereAreMoreOrNoSurvivors();
        
        uint256 totalPrizePool = s_totalPrizePool;
        _updateSurvivorRecord();
        address[] memory survivors = _getLasSurvivorsRecordArray();

        if (survivors.length != 1) revert Gluttons__ThereAreMoreOrNoSurvivors();

        if (address(this).balance < totalPrizePool) revert Gluttons__InsuficientBalanceInContract();


        _safeTransferETH(survivors[0], totalPrizePool);
        emit PrizeClaimed(survivors[0], totalPrizePool);


        s_gameActive = false;
        emit GameEndedBySingleSurvivor(survivors[0]);

    }

    /**
     * Prize given if all living Gluttons vote to divide the prize - used to send the money to all the living Gluttons available and ends the game
     */
    function _PrizeForVoteWinners() private nonReentrant {
        _updateSurvivorRecord();
        if (getAlivePetCount() <= 1) revert Gluttons__ThereAreSurvivors();
        
        uint256 totalPrizePool = s_totalPrizePool;
        address[] memory survivors = _getLasSurvivorsRecordArray();
        uint256 share = totalPrizePool / survivors.length;

        if (address(this).balance < totalPrizePool) revert Gluttons__InsuficientBalanceInContract();

        for (uint256 i = 0; i < survivors.length; i++) {
            _safeTransferETH(survivors[i], share);
            emit PrizeClaimed(survivors[i], share);
        }

        s_gameActive = false;
        emit GameEndedByVote(survivors.length);

    }

    /*
     * Prize claiming - Function to claim eth (ape) back form the pool after certain
     * conditions have been set
     
    function _claimPrize(uint256 tokenId) private nonReentrant returns (bool claimed) {
        // revisar para que no puedan hacer claim más de una vez
        if (s_gameActive) revert Gluttons__GameStillActive();


        address[] memory survivors = _getLasSurvivorsRecordArray();
        uint256 share = 0;

        if (getAlivePetCount() > 1) {
            Pet memory user = s_pets[tokenId];
            if (user.claim == true) revert Gluttons__AlreadyClaimedPrice();
            if (!_exists(tokenId)) revert Gluttons__NotASurvivor();
            if (user.alive == false) revert Gluttons__NotASurvivor();
            if (ownerOf(tokenId) != msg.sender) revert Gluttons__NotTheOwnerOfTheToken();
            // Game ended by vote - split among survivors
            share = s_totalPrizePool / getAlivePetCount();

            // Prevent reentrancy
            //s_totalPrizePool -= share; this generates that after each claim, everyone claims less
            payable(msg.sender).transfer(share);
            s_pets[tokenId].claim = true;
            emit PrizeClaimed(msg.sender, share);

            return claimed = true;
        } else if (getAlivePetCount() == 1)  {

        } else {
            // Game ended by extinction - split among last survivors
            if (s_lastSurvivors.survivors.length == 0) revert Gluttons__NoSurvivors();
            if (s_addressClaimed[msg.sender] == true) revert Gluttons__AddressAlreadyClaimed();
            //require(lastSurvivors.survivors.length > 0, "No survivor record");
            if (!_wasLastSurvivor(msg.sender)) revert Gluttons__NotInLastSurvivorsSet();
            share = s_totalPrizePool / s_lastSurvivors.survivors.length;
            //require(_wasLastSurvivor(msg.sender), "Not in last survivor set");
            payable(msg.sender).transfer(share);

            s_addressClaimed[msg.sender] = true;

            emit PrizeClaimed(msg.sender, share);

            return claimed = true;
        }
    }
    */

    // Admin functions (only for setup)
    /**
     * Function to withdraw shares for the devs, only for safetyMethod in case extra eth come into contract
     */
    function withdrawDevShare() external onlyOwner {
        uint256 balance = address(this).balance - s_totalPrizePool;
        uint256 dev1Balance = (balance * 50) / 100;
        uint256 dev2Balance = balance - dev1Balance;
        (bool dev1Success,) = payable(i_dev1).call{value: dev1Balance}(""); //transfer(dev1Balance);
        (bool dev2Success,) = payable(i_dev2).call{value: dev2Balance}(""); //transfer(dev2Balance);

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
    function _beforeTokenTransfers(address from, address to, uint256 startTokenId, uint256 quantity)
        internal
        virtual
        override
    {
        if (from != address(0) && to != address(0)) {
            if (msg.value != 0) {
                uint256 royalty = (msg.value * 10) / 100;
                (bool success,) = address(this).call{value: royalty}("");
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
        (bool success,) = to.call{value: value}("");
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
        for (uint256 i = 0; i < s_lastSurvivors.survivors.length; i++) {
            if (s_lastSurvivors.survivors[i] == claimant) return true;
        }
        return false;
    }

    /**
     * Get Oracle address
     */
    function getOracle() public view returns (address) {
        return s_oracle;
    }

    function getTraitsLockedStatus() external view returns(bool) {
        return s_traitsLocked;
    }

    function getPetPrice() external pure returns(uint256) {
        return PET_PRICE;
    }

    function getMaxSupply() external pure returns (uint256) {
        return MAX_PETS;
    }

    function getFoodContract() public view returns(address) {
        return s_foodContract;
    }

    function getPetInfo(uint256 _token) external view returns(Pet memory) {
        return s_pets[_token];
    }

    function getlastReaperCall() external view returns (uint256) {
        return s_lastReaperCall;
    }

    function getGameActiveStatus() external view returns (bool) {
        return s_gameActive;
    }

    function getLasSurvivorsRecord() external view returns (SurvivorRecord memory) {
        return s_lastSurvivors;
    }

    function _getLasSurvivorsRecordArray() internal view returns (address[] memory) {
        return s_lastSurvivors.survivors;
    }

    function checkIdTokenHasVoted(uint256 _token) external view returns(bool){
        return s_hasVoted[_token];
    }

    function getTotalVotes() external view returns(uint256) {
        return s_totalVotes;
    }

    /**
     * Gets the amount of alive pets
     */
    function getAlivePetCount() public view returns (uint256) {
        uint256 count = 0;
        for (uint256 i = 0; i < MAX_PETS; i++) {
            if (_exists(i) && s_pets[i].alive) count++;
        }
        return count;
    }

    /**
     * Get the amount of s_totalPrizePool
     */
    function getTotalPrizePool() public view returns (uint256) {
        return s_totalPrizePool;
    }

    /**
     * Get the balance of the Gluttons contract
     */
    function getGluttonsContractBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
