pragma solidity ^0.6.0;

import "./FfyiCard.sol";

contract FfyiCardAuction
{
    address public nftAddress;
    struct FfyiCardAuction {
        address payable seller;
        uint256 startingPrice;
        uint256 cardId;
    }
    mapping (uint256 => FfyiCardAuction) cardIdToAuction;
    FfyiCardAuction[] public       cardAuctions;
    /**
    * Constructor
    *
     */
    constructor(address _nftAddress) public
    {
        nftAddress = _nftAddress;
    }
    
    /**
    * Place an FfyiCard to Aunction on marketplace
    *
    * @param _price                 Price to Sell
    * @param _cardId                 FfyiCard Id
    *
     */
    function addAuction(uint _price, uint _cardId) external
    {
        require(_price > 0);
        FfyiCardAuction memory _auction = FfyiCardAuction(msg.sender, _price, _cardId);
        FfyiCard(nftAddress).transferFrom(msg.sender, address(this), _cardId);
        cardIdToAuction[_cardId] = _auction;
    }
    /**
    * Get Information of Auction By FfyiCard ID
    *
    * @param _cardId                 FfyiCard Id
    *
    * @return seller                Seller's Address
    * @return price                 Price
    * @return cardId                 FfyiCard Id
    *
     */
    function getFfyiCardAuctionByFfyiCardId(uint256 _cardId) external view returns(address seller, uint256 price, uint256 cardId)
    {
        FfyiCardAuction memory _auction = cardIdToAuction[_cardId];
        return(_auction.seller, _auction.startingPrice, _auction.cardId);
    }
    /**
    * Get Count of Auction Sale
    *
    * @return count                Count of Auction Sale
    *
     */
    function getFfyiCardAuctionCount() external view returns(uint256)
    {
        return cardAuctions.length;
    }
    /**
    * Get Information of Auction By Auction ID
    *
    * @param _auctionId             Auction Id
    *
    * @return seller                Seller's Address
    * @return price                 Price
    * @return cardId                 FfyiCard Id
    *
     */
    function getFfyiCardAuction(uint256 _auctionId) external view returns(address seller, uint256 price, uint256 cardId)
    {
        FfyiCardAuction memory _auction = cardAuctions[_auctionId];
        return(_auction.seller, _auction.startingPrice, _auction.cardId);
    }
    /**
    * Remove Auction By FfyiCard ID
    *
    * @param _cardId                 FfyiCard ID
    *
     */
    function _removeAuction(uint256 _cardId) internal {
        delete cardIdToAuction[_cardId];
    }
    /**
    * Bid on Auction Sale
    *
    * @param _cardId                 FfyiCard ID
    *
     */
    function bidAuction(uint256 _cardId) external payable
    {
        require(FfyiCard(nftAddress).ownerOf(_cardId) == address(this));
        FfyiCardAuction memory _auction = cardIdToAuction[_cardId];
        require(FfyiCard(nftAddress).ownerOf(_cardId) != msg.sender);
        require(_auction.startingPrice == msg.value);
        _removeAuction(_cardId);
        FfyiCard(nftAddress).transferFrom(address(this), msg.sender, _cardId);
        _auction.seller.transfer(msg.value);
    }
    /**
    * Cancel Auction By FfyiCard ID
    *
    * @param _cardId                 FfyiCard ID
    *
     */
    function cancelAuction(uint256 _cardId) external
    {
        require(FfyiCard(nftAddress).ownerOf(_cardId) == address(this));
        FfyiCardAuction memory _auction = cardIdToAuction[_cardId];
        require(msg.sender == _auction.seller);
        _removeAuction(_cardId);
        FfyiCard(nftAddress).transferFrom(address(this), msg.sender, _cardId);
    }
}