pragma solidity >=0.5.16;

import "./CardOwnership.sol";

contract CardMarketplace is CardOwnership
{
    struct CardAuction {
        address seller;
        uint256 startingPrice;
        uint256 cardId;
    }

    mapping (uint256 => CardAuction) cardIdToAuction;
    CardAuction[] public       cardAuctions;

    /**
    * Constructor
    *
     */
    constructor() public
    {

    }
}