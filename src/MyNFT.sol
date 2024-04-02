// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract Counter {
    uint256 public number;

    function setNumber(uint256 newNumber) public {
        number = newNumber;
    }

    function increment() public {
        number++;
    }
}

contract MyNFT is ERC721URIStorage {
    Counter private _tokenIds;

    constructor() ERC721("MyNFT", "NFT") {
        _tokenIds = new Counter();
    }

    function createNFT(address recipient, string memory tokenURI) public returns (uint256) {
        _tokenIds.increment();
        
        // Using the current value of number as the new token ID.
        uint256 newItemId = _tokenIds.number();
        _mint(recipient, newItemId);
        _setTokenURI(newItemId, tokenURI);
        
        return newItemId;
    }
}

