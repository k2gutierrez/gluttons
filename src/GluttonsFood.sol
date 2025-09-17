    // SPDX-License-Identifier: MIT
    pragma solidity ^0.8.24;

    import {ERC721A} from "@ERC721A/contracts/ERC721A.sol";
    import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
    import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
    import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";
    import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
    //import {GluttonsFoodImage} from "./GluttonsFoodImage.sol";

    /**
     * @title GluttonsFood
     * @author NFT Gamefied expierence to feed a Glutton daily, all the money 
     * except 10% goes to a pool, last man standing get the pool or if a vote
     * is made the pool can be divided to the last survivors.
     * @author Carlos Enrique Gutiérrez Chimal
     * @author Github - k2gutierrez
     * @author X - CarlosDappsDev.eth
     * @author 0xca067E20db2cDEF80D1c7130e5B71C42c0305529
     */
    contract GluttonsFood is ERC721A, Ownable, ReentrancyGuard {

        /* CUSTOM ERRORS */
        error GluttonsFood__NotEnoughApe();
        error GluttonsFood__transferNotAllowed();
        error GluttonsFood__FoodIsNotYours(uint256 tokenId);
        error GluttonsFood__AddressAlreadySet(address gluttonsContract);
        error GluttonsFood__WithdrawTransferFailed();
        error GluttonsFood__NotAGluttonsNFTHolder();
        error GluttonsFood__ZeroValueToTransfer();

        /* TYPES */
        // Used for checking the balances.
        enum Stakeholders {
            HOLDERS,
            DEVS
        }

        /* CONSTANTS */
        // price for 7 ERC721A NFTs.
        uint256 private constant FOOD7_PRICE = 1e4; // 14e18   1e4
        // price for 30 ERC721A NFTs.
        uint256 private constant FOOD30_PRICE = 2e4; // 30e18   2e4
        // Gluttons Image
        string private constant GLUTTONS_FOOD_IMAGE = "mmjsnjpbtl5ljiubjf5wz3m4mo4nn7pti4cfj34cib24zlc636aq.ardrive.net/YxMmpeGa-rSigUl7bO2cY7jW_fNHBFTvgkB1zKxe34E?";
        
        // address of the developer 1.
        address private immutable i_dev1;
        // address of the developer 2.
        address private immutable i_dev2;

        /* Variables */
        // Can only be set once with a function to have transparency, the address of the NFT contract that holds the gluttons.
        address private immutable i_gluttonsGameContract;

        // Used to check if transfers are allowed or not.
        bool private s_transferStatus = false;

        // Mapping used to get the balance assigned for the developers and for the game.
        mapping(Stakeholders => uint256 stakeholderBalance) private s_balances;

        /* EVENTS */
        // Notifies when an NFT is burned as a feeding action for the Glutton ERC721A NFT.
        event foodSpent(uint256 indexed tokenId, address feeder);
        // Notifies when eth is sent to the game contract.
        event valueSentToGameContract(address gameContract, uint256 value);
        // Notifies when eth is sent to the developers.
        event valueForDevs(address dev, uint256 value);

        /* MODIFIERS */
        // Cheks if the msg.sender is the owner of the ERC721A NFT.
        modifier foodOwner(address _user,uint256 tokenId){
            if (ownerOf(tokenId) != _user) {
                revert GluttonsFood__FoodIsNotYours(tokenId);
            }
            _;
        }

        constructor(address _dev1, address _dev2, address _gameContract) 
        ERC721A("GluttonsFood", "GtnsFOOD") 
        Ownable(msg.sender)
        {
            i_dev1 = _dev1;
            i_dev2 = _dev2;
            i_gluttonsGameContract = _gameContract;
        }

        /**
         * @dev changes the status of "s_transferStatus" to allow or disallow transfers between holders.
         */
        function changeTransferStatus() external onlyOwner {
            s_transferStatus = !s_transferStatus;
        }

        /**
         * @dev mint function to purchase 7 NFTs
         * function to purchase 7 NFTs, track balances and send the eth to developers and the game address.
         */
        function mintFoodPackWeek(address _user) external payable nonReentrant returns(bool) {
            if (ERC721A(getGluttonsGameContract()).balanceOf(_user) == 0) revert GluttonsFood__NotAGluttonsNFTHolder();
            if (msg.value < FOOD7_PRICE) revert GluttonsFood__NotEnoughApe();
            uint256 pack = 7;
            _mint(_user, pack);
            uint256 devsValue = (msg.value * 10) / 100;
            uint256 holdersValue = msg.value - devsValue;
            s_balances[Stakeholders.DEVS] += devsValue;
            s_balances[Stakeholders.HOLDERS] += holdersValue;

            uint256 dev1Value = (devsValue * 50) / 100;
            uint256 dev2Value = devsValue - dev1Value;

            _safeTransferETH(getGluttonsGameContract(), holdersValue);
            _safeTransferETH(i_dev1, dev1Value);
            _safeTransferETH(i_dev2, dev2Value);

            emit valueSentToGameContract(getGluttonsGameContract(), holdersValue);
            emit valueForDevs(i_dev1, dev1Value);
            emit valueForDevs(i_dev2, dev2Value);

            return true;
        }

        /**
         * @dev mint function to purchase 30 NFTs
         * function to purchase 30 NFTs, track balances and send the eth to developers and the game address.
         */
        function mintFoodPackMonth(address _user) external payable nonReentrant returns(bool) {
            if (ERC721A(getGluttonsGameContract()).balanceOf(_user) == 0) revert GluttonsFood__NotAGluttonsNFTHolder();
            if (msg.value < FOOD30_PRICE) revert GluttonsFood__NotEnoughApe();
            uint256 pack = 30;
            _mint(_user, pack);
            uint256 devsValue = (msg.value * 10) / 100;
            uint256 holdersValue = msg.value - devsValue;
            s_balances[Stakeholders.DEVS] += devsValue;
            s_balances[Stakeholders.HOLDERS] += holdersValue;

            uint256 dev1Value = (devsValue * 50) / 100;
            uint256 dev2Value = devsValue - dev1Value;

            _safeTransferETH(getGluttonsGameContract(), holdersValue);
            _safeTransferETH(i_dev1, dev1Value);
            _safeTransferETH(i_dev2, dev2Value);

            emit valueSentToGameContract(getGluttonsGameContract(), holdersValue);
            emit valueForDevs(i_dev1, dev1Value);
            emit valueForDevs(i_dev2, dev2Value);
            
            return true;
        }

        /**
         * 
         * @param tokenId tokenId of the Food NFT that the msg.sender has to feed the glutton, token is burned.
         */
        function feedGlutton(address _user, uint256 tokenId) external foodOwner(_user, tokenId) nonReentrant returns(bool) {
            _burn(tokenId);
            emit foodSpent(tokenId, _user);
            return true;
        }

        /**
         * Function to return any eth left in food contract to the Owner
         * Mint functions transfers eth to Game Contract, this is just a prevention function for the owner
         */
        function withDrawFunds() external onlyOwner {
            _safeTransferETH(owner(), address(this).balance);
        }

        /**
         * Add fail-safe for ETH transfers
         * @param to address to send eth
         * @param value eth sent to the "to" address
         */
        function _safeTransferETH(address to, uint256 value) private {
            if (value == 0) revert GluttonsFood__ZeroValueToTransfer();
            (bool success, ) = to.call{value: value}("");
            if (!success) revert GluttonsFood__WithdrawTransferFailed();
        }

        /**
         * Hook provided in the ERC721A to add the soulbound function to prevent or not transfer functions.
         * @param from used to check if it is address(0) or not.
         * @param to used to check if it is address(0) or not.
         * @param startTokenId not used in this override.
         * @param quantity not used in this override.
         */
        function _beforeTokenTransfers(
            address from,
            address to,
            uint256 startTokenId,
            uint256 quantity
        ) internal override {
            if (from != address(0) && to != address(0)) {
                if (checkTransferStatus() == false){
                    revert GluttonsFood__transferNotAllowed();
                }
            }
            super._beforeTokenTransfers(from, to, startTokenId, quantity);
        }

        function _baseURI() internal pure override returns(string memory){
            return "data:application/json;base64,";
        }

        /**
         * Token Uri
         */
        function tokenURI(uint256 tokenId) public view override returns (string memory){

            string memory token = Strings.toString(tokenId);

            return string(abi.encodePacked(_baseURI(),
            Base64.encode(bytes(abi.encodePacked('{"name": "', name(), ' #', token, '", "description": "An NFT that serves as food for a Glutton.", "attributes": [{"trait_type": "Gluttony", "value": 100}], "image": "', GLUTTONS_FOOD_IMAGE, '"}')))));
        }


        /**
         * Returns the Gluttons Game Contract.
         */
        function getGluttonsGameContract() public view returns(address) {
            return i_gluttonsGameContract;
        }

        /**
         * Returns the transfer status of NFTs between holders.
         */
        function checkTransferStatus() public view returns(bool) {
            return s_transferStatus;
        }

        /**
         * Returns the balance registered (not necessarily holded in this contract) of the holders.
         */
        function checkHoldersBalance() public view returns(uint256) {
            return s_balances[Stakeholders.HOLDERS];
        }

        /**
         * Returns the balance registered (not necessarily holded in this contract) of the devs.
         */
        function checkDevsBalance() public view returns(uint256) {
            return s_balances[Stakeholders.DEVS];
        }

        /**
         * Returnos Contract Balaance
         */
        function contractBalance() public view returns(uint256){
            return address(this).balance;
        }

        /**
         * Returns the price of the 7 pack NFTs.
         */
        function getFoodPrice7Pack() public pure returns(uint256){
            return FOOD7_PRICE;
        }

        /**
         * Returns the price of the 30 pack NFTs.
         */
        function getFoodPrice30Pack() public pure returns(uint256){
            return FOOD30_PRICE;
        }

    }