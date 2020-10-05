pragma solidity >=0.5.16;

contract CardBase
{
    struct Card {
        string  picture;
        uint    cardType;
    }

    address public                          addrAdmin;

    Card[]   public                         cards;

    mapping (uint256 => address) public     cardIndexToOwner;
    mapping (address => uint256) public     ownershipCardCount;
    mapping (uint256 => address) public     cardIndexToApproved;

    event Transfer(address from, address to, uint256 cardId);

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
    * @param _cardType                              Type of Card
    *
     */
    function _createCard(address _cardOwner, string memory _picture, uint256 _cardType) internal
    {
        cards.push(Card(_picture, _cardType));
        uint256 newCardId = cards.length - 1;
        _transfer(address(0), _cardOwner, newCardId);
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
