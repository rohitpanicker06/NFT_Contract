// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "./Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFTCollections is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    Counters.Counter private _collectionIds;

    struct Collection {
        uint256 id;
        string name;
        address owner;
    }

    struct ListedToken {
        uint256 tokenId;
        uint256 collectionId;
        address owner;
    }

    // Mapping from collection ID to collection
    mapping(uint256 => Collection) private collections;

    // Mapping from token ID to listed token
    mapping(uint256 => ListedToken) private listedTokens;


    // Mapping from collection ID to list of token IDs
    mapping(uint256 => uint256[]) private collectionToTokens;

    event CollectionCreated(uint256 indexed collectionId, string name, address indexed owner);
    event TokenCreated(uint256 indexed tokenId, uint256 indexed collectionId, address indexed owner, string tokenURI);

    constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol) {}

    function createCollection(string memory name) public {
        _collectionIds.increment();
        uint256 newCollectionId = _collectionIds.current();

        collections[newCollectionId] = Collection(newCollectionId, name, msg.sender);
        emit CollectionCreated(newCollectionId, name, msg.sender);
    }

    function createToken(uint256 collectionId, string memory tokenURI) public {
        require(collections[collectionId].owner == msg.sender, "You must own the collection to create a token in it.");

        _tokenIds.increment();
        uint256 newTokenId = _tokenIds.current();

        _safeMint(msg.sender, newTokenId);
        _setTokenURI(newTokenId, tokenURI);

        listedTokens[newTokenId] = ListedToken(newTokenId, collectionId, msg.sender);
        collectionToTokens[collectionId].push(newTokenId);

        emit TokenCreated(newTokenId, collectionId, msg.sender, tokenURI);
    }

    function getAllCollections() public view returns (Collection[] memory) {
        uint totalCollectionCount = _collectionIds.current();
        Collection[] memory collectionList = new Collection[](totalCollectionCount);
        for (uint i = 0; i < totalCollectionCount; i++) {
            Collection storage collection = collections[i + 1];
            collectionList[i] = collection;
        }
        return collectionList;
    }

    function getTokensInCollection(uint256 collectionId) public view returns (ListedToken[] memory) {
        uint256[] memory tokenIds = collectionToTokens[collectionId];
        ListedToken[] memory tokens = new ListedToken[](tokenIds.length);
        for (uint i = 0; i < tokenIds.length; i++) {
            ListedToken storage token = listedTokens[tokenIds[i]];
            tokens[i] = token;
        }
        return tokens;
    }

    function getMyCollections() public view returns (Collection[] memory) {
        uint totalCollectionCount = _collectionIds.current();
        uint itemCount = 0;

        for (uint i = 0; i < totalCollectionCount; i++) {
            if (collections[i + 1].owner == msg.sender) {
                itemCount++;
            }
        }

        Collection[] memory myCollections = new Collection[](itemCount);
        uint currentIndex = 0;

        for (uint i = 0; i < totalCollectionCount; i++) {
            if (collections[i + 1].owner == msg.sender) {
                myCollections[currentIndex] = collections[i + 1];
                currentIndex++;
            }
        }
        return myCollections;
    }


}
