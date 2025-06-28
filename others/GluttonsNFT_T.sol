// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

error GluttonsNFT__ZeroAddressNotAllowed();
error GluttonsNFT__InsufficientAmount(uint256 value);
error GluttonsNFT__MaxSupplyReached();
error GluttonsNFT__NonExistentTokenURI();
error GluttonsNFT__WithdrawTransferFailed();
error GluttonsNFT__WithdrawTransferFailedNoBalance();
error GluttonsNFT__NoExternalContractInteractionAllowed();
error GluttonsNFT__AddressCanOnlyBeSetOnce();

contract GluttonsNFT is ERC721, Ownable, ReentrancyGuard {
    using Strings for uint256;

    address private constant OWNER = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
    address private constant DEV = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
    uint256 public constant TOTAL_SUPPLY = 2500;
    uint256 public constant MINT_PRICE = 80 ether;
    
    address private s_gameContract;
    string public s_baseURI;
    uint256 public s_currentTokenId;
    bool private s_addGameContractOnce = true;

    constructor(
        string memory _name,
        string memory _symbol,
        string memory _URI
    ) ERC721(_name, _symbol) Ownable(msg.sender) {
        s_baseURI = _URI;
    }

    event BalanceWithdrawn(address game, uint256 game_90, uint256 dev_5, uint256 owner_5);

    modifier noContract { // this won't allow external contracts to interact with functions
        if (tx.origin != msg.sender) revert GluttonsNFT__NoExternalContractInteractionAllowed();
        _;
    }

    function setGameContract(address _gameContract) external onlyOwner {
        if (s_addGameContractOnce == false) revert GluttonsNFT__AddressCanOnlyBeSetOnce();
        s_gameContract = _gameContract;
        s_addGameContractOnce = false;
    }

    function mintTo(address recipient) public payable noContract nonReentrant returns (uint256) {
        if (msg.sender == address(0)) {
            revert GluttonsNFT__ZeroAddressNotAllowed();
        }
        if (msg.value < MINT_PRICE) {
            revert GluttonsNFT__InsufficientAmount(msg.value);
        }
        uint256 newTokenId = s_currentTokenId + 1;
        if (newTokenId > TOTAL_SUPPLY) {
            revert GluttonsNFT__MaxSupplyReached();
        }
        s_currentTokenId = newTokenId;
        _safeMint(recipient, newTokenId);
        return newTokenId;
    }

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        if (ownerOf(tokenId) == address(0)) {
            revert GluttonsNFT__NonExistentTokenURI();
        }
        return
            bytes(s_baseURI).length > 0
                ? string(abi.encodePacked(s_baseURI, tokenId.toString()))
                : "";
    }

    function withdrawBalance() external onlyOwner noContract nonReentrant {
        uint256 balanceOfContract = getBalance();
        
        if (balanceOfContract <= 0) revert GluttonsNFT__WithdrawTransferFailedNoBalance();
        
        uint256 gameAmount = (balanceOfContract * 90) / 100;
        uint256 devAmount = (balanceOfContract * 5) / 100;
        uint256 ownerAmount = balanceOfContract - gameAmount - devAmount;

        (bool gameSuccess, ) = payable(s_gameContract).call{value: gameAmount}("");
        (bool devSuccess, ) = payable(DEV).call{value: devAmount}("");
        (bool ownerSuccess, ) = payable(OWNER).call{value: ownerAmount}("");

        if (!gameSuccess || !devSuccess || !ownerSuccess) {
            revert GluttonsNFT__WithdrawTransferFailed();
        }

        emit BalanceWithdrawn(s_gameContract, gameAmount, devAmount, ownerAmount);

    }

    function _checkOwner() internal view override {
        require(msg.sender == owner(), "Ownable: caller is not the owner");
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}

    