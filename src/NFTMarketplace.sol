pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "../src/Counters.sol";

contract NFTMarketplace is ERC721URIStorage {

    address  owner;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    constructor() ERC721("NFTMarketPlace","NFTM"){
        owner = msg.sender;
    }

    struct ListedToken{
     uint256 tokenId;
     address owner;
    }

    mapping(uint256 => ListedToken) private idToListedToken;

    function getLatestIdtoListedToken() public view returns (ListedToken memory){
        uint256 currentTokenId = _tokenIds.current();
        return  idToListedToken[currentTokenId];
    }

    function getListedForTokenId(uint256 tokenId) public view returns (ListedToken memory)
    {
    return idToListedToken[tokenId];
    }

    function getCurrentToken() public view returns (uint256)
    {
        return _tokenIds.current();
    }

    function createToken(string memory tokenURI) public returns (uint)
    {
    require(owner == msg.sender, "Owner can only create token");
        _tokenIds.increment();
        uint256 currentTokenId = _tokenIds.current();
    _safeMint(msg.sender, currentTokenId);
        _setTokenURI(currentTokenId,tokenURI);

        createListedToken(currentTokenId);
        return currentTokenId;
    }

    function createListedToken(uint256 tokenId) private
    {
        idToListedToken[tokenId] = ListedToken(tokenId, msg.sender);
        _transfer(msg.sender,msg.sender, tokenId);
    }

    function getAllNFTs() public view returns (ListedToken[] memory)
    {
        uint totalNftCount = _tokenIds.current();
        ListedToken[] memory tokens = new ListedToken[](totalNftCount);

        uint currentIndex = 0;

        for(uint i = 0;i<totalNftCount;i++)
        {
            uint currentId = i+1;
            ListedToken storage currentItem = idToListedToken[currentId];
            tokens[currentIndex] = currentItem;
            currentIndex +=1;
        }
        return tokens;
    }


    function getMyNFTs() public view returns (ListedToken[] memory)
    {
        uint totalNftCount = _tokenIds.current();
        uint itemCount = 0;
        uint currentIndex = 0;

        for(uint i = 0;i<totalNftCount;i++)
        {
            if(idToListedToken[i+1].owner == msg.sender){
                itemCount +=1;
            }
        }

        ListedToken[] memory tokens = new ListedToken[](itemCount);
        for(uint i = 0;i<totalNftCount;i++)
        {
            if(idToListedToken[i+1].owner == msg.sender){
            uint currentId = i+1;
            ListedToken storage currentItem = idToListedToken[currentId];
            tokens[currentIndex] = currentItem;
            currentIndex +=1;
        }
        }
    return tokens;
    }

}