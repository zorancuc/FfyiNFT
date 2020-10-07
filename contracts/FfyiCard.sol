pragma solidity ^0.6.0;

import "./ERC721Tradable.sol";
import "openzeppelin-solidity/contracts/access/Ownable.sol";

/**
 * @title FfyiCard
 * FfyiCard - a contract for my non-fungible ffyiCards.
 */
contract FfyiCard is ERC721Tradable {
  constructor(address _proxyRegistryAddress) ERC721Tradable("FfyiCard", "OSC", _proxyRegistryAddress) public {  }
}
