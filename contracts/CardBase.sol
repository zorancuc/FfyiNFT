pragma solidity >=0.5.16;

contract CardBase
{
    struct Card {
        string  picture;
        uint    type;
    }

    address public                          addrAdmin;

    Card[]   public                         cards;

    mapping (uint256 => address) public     cardIndexToOwner;
    mapping (address => uint256) public     ownershipCardCount;
    mapping (uint256 => address) public     cardIndexToApproved;

    event Transfer(address from, address to, uint256 cardId);
    event CardsCreated(uint itmeType, uint quantity);

    /**
    * Constructor
    *
     */
    constructor() public
    {
        addrAdmin = msg.sender;
    }

    /**
    * Modifier for Admin Only
    *
     */
    modifier onlyAdmin()
    {
        require(msg.sender == addrAdmin);
        _;
    }

    /**
    * Create Card NFT
    * @param _cardOwner                         Address of new Card's Owner
    * @param _picture                           Link of card's picture
    * @param _type                              Type of Card
    *
     */
    function _createCard(address _cardOwner, string _picture, uint256 _type) internal
    {
        Card memory _card = Card(_picture, _type);

        uint256 newCardId = cards.push(_card) - 1;
        _transfer(0, _cardOwner, newCardId);
    }

    /**
    * Transfer Card
    * @param _from                          Address of transfer
    * @param _to                            Address of receiver
    * @param _cardId                         Card Id to be transferred
    *
     */
    function _transfer(address _from, address _to, uint256 _cardId) internal
    {
        ownershipCardCount[_to]++;
        cardIndexToOwner[_cardId] = _to;
        if (_from != address(0)) {
            ownershipCardCount[_from]--;
            delete cardIndexToApproved[_cardId];
        }
        
        emit Transfer(_from, _to, _cardId);
    }
}
