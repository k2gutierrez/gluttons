// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract GluttonFood is ERC20, Ownable, ReentrancyGuard {

    error GluttonFood__IncorrectAmountForPurchase(uint256 amountForPurchase);
    error GluttonFood__NotTheOwnerOfTheNFT();
    error GluttonFood__NoTransferAllowed();
    error GluttonFood__NoExternalContractInteractionAllowed();
    error GluttonFood__WithdrawTransferFailedNoBalance();
    error GluttonFood__WithdrawTransferFailed();
    error GluttonFood__AddressCanOnlyBeSetOnce();

    address private constant OWNER = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
    address private constant DEV = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
    uint256 private constant SINGLE_FOOD = 1 ether;
    uint256 private constant PACKAGE_10_FOODS = 5 ether;
    uint256 private constant PACKAGE_30_FOODS = 10 ether;

    address private immutable i_nftAddressAprovedToPurchase;

    address private s_gameContract;
    bool private s_addGameContractOnce = true;
    bool private s_transferable = false;
    
    constructor(address _nftAddress) Ownable(msg.sender) ERC20("GluttonsFood", "GF") {
        i_nftAddressAprovedToPurchase = _nftAddress;
    }

    event BalanceWithdrawn(address game, uint256 game_90, uint256 dev_5, uint256 owner_5);

    modifier noContract { // this won't allow external contracts to interact with functions
        if (tx.origin != msg.sender) revert GluttonFood__NoExternalContractInteractionAllowed();
        _;
    }

    modifier approvedNft(uint256 nft) {
        if (ERC721(i_nftAddressAprovedToPurchase).ownerOf(nft) != msg.sender){
            revert GluttonFood__NotTheOwnerOfTheNFT();
        }
        _;
    }

    modifier transferStatus(){
        if (s_transferable == false) {
            revert GluttonFood__NoTransferAllowed();
        }
        _;
    }

    function setGameContract(address _gameContract) external onlyOwner noContract nonReentrant {
        if (s_addGameContractOnce == false) revert GluttonFood__AddressCanOnlyBeSetOnce();
        s_gameContract = _gameContract;
        s_addGameContractOnce = false;
    }

    function changeTransferStatus() external onlyOwner {
    s_transferable = !s_transferable;
}
    
    function mint(address _to, uint256 _amount) public payable nonReentrant {
        if (msg.value < SINGLE_FOOD * _amount) revert GluttonFood__IncorrectAmountForPurchase(msg.value);
        _mint(_to, _amount);
    }

    /**
     * Function to buy food ERC20 tokens for the Gluttons
     * @param _to address of the player buying Food (tokens) for his Glutton
     * @dev this function is to purchase the amount of 10 ERC20s
     */
    function mintPackageOf10Foods(address _to, uint256 _nft) public payable nonReentrant approvedNft(_nft) {
        if (msg.value < PACKAGE_10_FOODS) revert GluttonFood__IncorrectAmountForPurchase(msg.value);

        uint256 amountToMint = 10;
        _mint(_to, amountToMint);
    }

    /**
     * Function to buy food ERC20 tokens for the Gluttons
     * @param _to address of the player buying Food (tokens) for his Glutton
     * @dev this function is to purchase the amount of 10 ERC20s
     */
    function mintPackageOf30Foods(address _to, uint256 _nft) public payable nonReentrant approvedNft(_nft) {
        if (msg.value < PACKAGE_30_FOODS) revert GluttonFood__IncorrectAmountForPurchase(msg.value);

        uint256 amountToMint = 30;
        _mint(_to, amountToMint);
    }

    /**
     * 
     * @param _from address of the player that is feeding the Glutton (feed = burn token)
     */
    function burn(address _from, uint256 _amount) public {
        _burn(_from, _amount); // Use the _burn function to destroy tokens
    }

    /**
     * @dev We want the decimals to be 0 so no token can be splitted in any type of fraction
     */
    function decimals() public pure override returns (uint8) {
        return 0;
    }

    /**
     * @dev See {IERC20-transfer}.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     * - the caller must have a balance of at least `value`.
     */
    function transfer(address to, uint256 value) public override transferStatus returns (bool) {
        address owner = _msgSender();
        _transfer(owner, to, value);
        return true;
    }

    /**
     * @dev See {IERC20-transferFrom}.
     *
     * Skips emitting an {Approval} event indicating an allowance update. This is not
     * required by the ERC. See {xref-ERC20-_approve-address-address-uint256-bool-}[_approve].
     *
     * NOTE: Does not update the allowance if the current allowance
     * is the maximum `uint256`.
     *
     * Requirements:
     *
     * - `from` and `to` cannot be the zero address.
     * - `from` must have a balance of at least `value`.
     * - the caller must have allowance for ``from``'s tokens of at least
     * `value`.
     */
    function transferFrom(address from, address to, uint256 value) public override transferStatus returns (bool) {
        address spender = _msgSender();
        _spendAllowance(from, spender, value);
        _transfer(from, to, value);
        return true;
    }

    function withdrawBalance() external onlyOwner noContract nonReentrant {
        uint256 balanceOfContract = getBalance();
        
        if (balanceOfContract <= 0) revert GluttonFood__WithdrawTransferFailedNoBalance();
        
        uint256 gameAmount = (balanceOfContract * 90) / 100;
        uint256 devAmount = (balanceOfContract * 5) / 100;
        uint256 ownerAmount = balanceOfContract - gameAmount - devAmount;

        (bool gameSuccess, ) = payable(s_gameContract).call{value: gameAmount}("");
        (bool devSuccess, ) = payable(DEV).call{value: devAmount}("");
        (bool ownerSuccess, ) = payable(OWNER).call{value: ownerAmount}("");

        if (!gameSuccess || !devSuccess || !ownerSuccess) {
            revert GluttonFood__WithdrawTransferFailed();
        }

        emit BalanceWithdrawn(s_gameContract, gameAmount, devAmount, ownerAmount);

    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

}