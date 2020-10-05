pragma solidity >=0.5.16;

import "./CardBase.sol";
import "./TRC721.sol";
import "./TRC721Metadata.sol";

contract CardOwnership is CardBase, TRC721
{
    string public constant name = "FfyiCard";
    string public constant symbol = "Card";

    TRC721Metadata public trc721Metadata;

    bytes4 constant InterfaceSignature_TRC165 =
        bytes4(keccak256('supportsInterface(bytes4)'));

    bytes4 constant InterfaceSignature_TRC721 =
        bytes4(keccak256('name()')) ^
        bytes4(keccak256('symbol()')) ^
        bytes4(keccak256('totalSupply()')) ^
        bytes4(keccak256('balanceOf(address)')) ^
        bytes4(keccak256('ownerOf(uint256)')) ^
        bytes4(keccak256('approve(address,uint256)')) ^
        bytes4(keccak256('transfer(address,uint256)')) ^
        bytes4(keccak256('transferFrom(address,address,uint256)')) ^
        bytes4(keccak256('cardsOfOwner(address)')) ^
        bytes4(keccak256('tokenMetadata(uint256,string)'));

    function supportsInterface(bytes4 _interfaceID) external view returns (bool)
    {
        return ((_interfaceID == InterfaceSignature_TRC165) || (_interfaceID == InterfaceSignature_TRC721));
    }

    /**
    * Set Meta Data Address of TRC721
    * @param _contractAddress                      Address of TRC721
    *
     */
    function setMetadataAddress(address _contractAddress) public onlyAdmin {
        trc721Metadata = TRC721Metadata(_contractAddress);
    }

    /**
    * Check if the claimant owns Card
    * @param _claimant                  Address of Claimer
    * @param _cardId                     Card Id
    *
    * @return result                    The boolean result if claimant owns given Card
    *
     */
    function _owns(address _claimant, uint256 _cardId) internal view returns (bool) {
        return cardIndexToOwner[_cardId] == _claimant;
    }

    /**
    * Check if card is approved for Claimant
    * @param _claimant                  Address of Claimer
    * @param _cardId                     Card Id
    *
    * @return result                    The boolean result if claimant is approved for given Card
    *
     */
    function _approvedFor(address _claimant, uint256 _cardId) internal view returns (bool) {
        return cardIndexToApproved[_cardId] == _claimant;
    }

    /**
    * Approve Card for for Claimant
    * @param _approved                  Address of approved
    * @param _cardId                     Card Id
    *
     */
    function _approve(uint256 _cardId, address _approved) internal {
        cardIndexToApproved[_cardId] = _approved;
    }

    /**
    * Get Balance of Owner
    * @return count                     Count of Cards owned by Owner
    *
     */
    function balanceOf(address _owner) public view returns (uint256 count) {
        return ownershipCardCount[_owner];
    }

    /**
    * Transfer Card
    * @param _to                            Address of receiver
    * @param _cardId                         Card Id to be transferred
    *
     */
    function transfer(
        address _to,
        uint256 _cardId
    )
        external
    {
        // Safety check to prevent against an unexpected 0x0 default.
        require(_to != address(0x0));
        require(_to != address(this));

        require(_owns(msg.sender, _cardId));

        _transfer(msg.sender, _to, _cardId);
    }

    /**
    * Approve Card for for Claimant
    * @param _to                        Address to be approved by Card
    * @param _cardId                     Card Id
    *
     */
    function approve(
        address _to,
        uint256 _cardId
    )
        external
    {
        // Only an owner can grant transfer approval.
        require(_owns(msg.sender, _cardId));

        // Register the approval (replacing any previous approval).
        _approve(_cardId, _to);

        // Emit approval event.
        emit Approval(msg.sender, _to, _cardId);
    }

    /**
    * Transfer Card
    * @param _from                          Address of transfer
    * @param _to                            Address of receiver
    * @param _cardId                         Card Id to be transferred
    *
     */
    function transferFrom(
        address _from,
        address _to,
        uint256 _cardId
    )
        external
    {
        require(_to != address(0));

        require(_to != address(this));

        require(_approvedFor(msg.sender, _cardId));
        require(_owns(_from, _cardId));

        _transfer(_from, _to, _cardId);
    }

    /**
    * Get Total Supply
    * @return count                     Total Supply of Cards
    *
     */
    function totalSupply() public view returns (uint) {
        return cards.length - 1;
    }

    /**
    * Get Owner of Given Card
    * @param _cardId                         Card Id
    * @return owner                         Owner's address of Card id
    *
     */
    function ownerOf(uint256 _cardId)
        public
        view
        returns (address owner)
    {
        owner = cardIndexToOwner[_cardId];

        require(owner != address(0x0));
    }

    /**
    * Get Cards of Owner
    * @param _owner                         Owner's address of Card id
    *
    * @return ownerCards                     Owner's Cards
    *
     */
    function cardsOfOwner(address _owner) public view returns(uint256[] ownerCards) {
        uint256 cardCount = balanceOf(_owner);

        if (cardCount == 0) {
            // Return an empty array
            return new uint256[](0);
        } else {
            uint256[] memory result = new uint256[](cardCount);
            uint256 totalcards = totalSupply();
            uint256 resultIndex = 0;

            uint256 cardId;

            for (cardId = 1; cardId <= totalcards; cardId++) {
                if (cardIndexToOwner[cardId] == _owner) {
                    result[resultIndex] = cardId;
                    resultIndex++;
                }
            }

            return result;
        }
    }

    function _memcpy(uint _dest, uint _src, uint _len) private pure {
        // Copy word-length chunks while possible
        for(; _len >= 32; _len -= 32) {
            assembly {
                mstore(_dest, mload(_src))
            }
            _dest += 32;
            _src += 32;
        }

        // Copy remaining bytes
        uint256 mask = 256 ** (32 - _len) - 1;
        assembly {
            let srcpart := and(mload(_src), not(mask))
            let destpart := and(mload(_dest), mask)
            mstore(_dest, or(destpart, srcpart))
        }
    }

    function _toString(bytes32[4] _rawBytes, uint256 _stringLength) private pure returns (string) {
        string memory outputString = new string(_stringLength);
        uint256 outputPtr;
        uint256 bytesPtr;

        assembly {
            outputPtr := add(outputString, 32)
            bytesPtr := _rawBytes
        }

        _memcpy(outputPtr, bytesPtr, _stringLength);

        return outputString;
    }
}
