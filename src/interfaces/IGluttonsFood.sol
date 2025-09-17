    // SPDX-License-Identifier: MIT
    pragma solidity ^0.8.30;

    /**
     * @title GluttonsFood Interface
     * @author NFT Gamefied expierence to feed a Glutton daily, all the money 
     * except 10% goes to a pool, last man standing get the pool or if a vote
     * is made the pool can be divided to the last survivors.
     * @author Carlos Enrique Gutiérrez Chimal
     * @author Github - k2gutierrez
     * @author X - CarlosDappsDev.eth
     * @author 0xca067E20db2cDEF80D1c7130e5B71C42c0305529
     */
    contract IGluttonsFood {
        
        function getFoodPrice7Pack() public pure returns(uint256){}

        function getFoodPrice30Pack() public pure returns(uint256){}

        function mintFoodPackWeek(address _user) external payable returns(bool) {}

        function mintFoodPackMonth(address _user) external payable returns(bool) {}

        function feedGlutton(address _user, uint256 tokenId) external returns(bool) {}

        function tokenURI(uint256 tokenId) public view returns (string memory){}

    }