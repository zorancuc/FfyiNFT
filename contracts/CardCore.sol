pragma solidity >=0.5.16;

import "./CardMarketplace.sol";

contract CardCore is CardMarketplace
{
    /**
    * Constructor
    *
     */
    constructor() public
    {

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
    * @param _cardType                              Type of card
    *
     */
    function createCardToOwner(address _cardOwner, string memory _picture, uint256 _cardType) public {
        _createCard(_cardOwner, _picture, _cardType);
    }

    /**
    * Get Information of an Card
    * @param _cardId                      Card Id
    *
    * @return picture                       Link of card's picture
    * @return cardType                      Type of Card
    *
     */
    function getCard(uint _cardId) public view returns(string memory , uint256)
    {
        Card memory _card = cards[_cardId];
        return(_card.picture, _card.cardType);
    }
}
