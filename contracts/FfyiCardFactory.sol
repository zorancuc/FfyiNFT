pragma solidity ^0.6.0;

import "openzeppelin-solidity/contracts/access/Ownable.sol";
import "./Factory.sol";
import "./FfyiCard.sol";
import "./FStrings.sol";

contract FfyiCardFactory is Factory, Ownable {
  using FStrings for string;

  event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

  address public proxyRegistryAddress;
  address public nftAddress;
  string public baseURI = "https://ffyiCards-api.opensea.io/api/factory/";

  /**
   * Enforce the existence of only 100 OpenSea ffyiCards.
   */
  uint256 FFYICARD_SUPPLY = 100;
  uint256 NUM_OPTIONS = 3;
  /**
   * Three different options for minting FfyiCards (basic, premium, and gold).
   */

  constructor(address _proxyRegistryAddress, address _nftAddress) public {
    proxyRegistryAddress = _proxyRegistryAddress;
    nftAddress = _nftAddress;
        
    fireTransferEvents(address(0), owner());
  }

  function name() external override view returns (string memory) {
    return "OpenSeaFfyiCard Item Sale";
  }

  function symbol() external override view returns (string memory) {
    return "CPF";
  }

  function supportsFactoryInterface() public override view returns (bool) {
    return true;
  }

  function numOptions() public override view returns (uint256) {
    return NUM_OPTIONS;
  }

  function transferOwnership(address newOwner) public override onlyOwner {
    address _prevOwner = owner();
    super.transferOwnership(newOwner);
    fireTransferEvents(_prevOwner, newOwner);
  }

  function fireTransferEvents(address _from, address _to) private {
    for (uint256 i = 0; i < NUM_OPTIONS; i++) {
      emit Transfer(_from, _to, i);
    }
  }

  function mint(uint256 _numItem, address _toAddress) public override {
    // Must be sent from the owner proxy or owner.
    ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
    assert(address(proxyRegistry.proxies(owner())) == msg.sender || owner() == msg.sender);
    require(canMint(_numItem));

    FfyiCard openSeaFfyiCard = FfyiCard(nftAddress);
    for (uint256 i = 0; i < _numItem; i++) {
      openSeaFfyiCard.mintTo(_toAddress);
    }
  }

  function canMint(uint256 _numItem) public override view returns (bool) {
    if (_numItem == 0) {
      return false;
    }

    if (_numItem == 0) {
      return false;
    }

    FfyiCard openSeaFfyiCard = FfyiCard(nftAddress);
    uint256 ffyiCardSupply = openSeaFfyiCard.totalSupply();

    return ffyiCardSupply < (FFYICARD_SUPPLY - _numItem);
  }

  function tokenURI(uint256 _optionId) external override view returns (string memory) {
    return FStrings.strConcat(
        baseURI,
        FStrings.uint2str(_optionId)
    );
  }

  /**
   * Hack to get things to work automatically on OpenSea.
   * Use transferFrom so the frontend doesn't have to worry about different method names.
   */
  function transferFrom(address _from, address _to, uint256 _tokenId) public {
    mint(_tokenId, _to);
  }

  /**
   * Hack to get things to work automatically on OpenSea.
   * Use isApprovedForAll so the frontend doesn't have to worry about different method names.
   */
  function isApprovedForAll(
    address _owner,
    address _operator
  )
    public
    view
    returns (bool)
  {
    if (owner() == _owner && _owner == _operator) {
      return true;
    }

    ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
    if (owner() == _owner && address(proxyRegistry.proxies(_owner)) == _operator) {
      return true;
    }

    return false;
  }

  /**
   * Hack to get things to work automatically on OpenSea.
   * Use isApprovedForAll so the frontend doesn't have to worry about different method names.
   */
  function ownerOf(uint256 _tokenId) public view returns (address _owner) {
    return owner();
  }
}
