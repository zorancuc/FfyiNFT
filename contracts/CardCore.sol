pragma solidity >=0.5.16;

import "./CardMarketplace.sol";

contract CardCore is CardMarketplace
{
    /**
    * Constructor
    * @param _addrGeneScience               Address of GeneScience contract
    *
     */
    constructor() public
    {

    }

    /**
    * Set Chest Address
    * @param _addrChest                      Address of Chest contract
    *
     */
    function setChestAddr(address _addrChest) public onlyAdmin
    {
        require(_addrChest != address(0x0));
        addrChest = _addrChest;

    }

    /**
    * Test function
    *
     */
    function cardTest() external view returns (address){
        return addrChest;
    }

    /**
    * Check function as if this is the Card contract
    *
     */
    function isCardContract() public pure returns (bool) {
        return true;
    }

    /**
    * Create Card and transfer to Owner
    * @param _cardOwner                         Address of Card Owner
    * @param _picture                           Link of card's picture
    * @param _type                              Type of card
    *
     */
    function createCardToOwner(address _cardOwner, string _picture, uint256 _type) public {
        _createCard(_cardOwner, _picture, _type);
    }

    /**
    * Get Information of an Card
    * @param _cardId                      Card Id
    *
    * @return picture                       Link of card's picture
    * @return type                          Type of Card
    *
     */
    function getCard(uint _cardId) public view returns(string, uint256)
    {
        Card memory _card = cards[_cardId];
        return(_card.picture, _card.type);
    }
}
