// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/NFTCollections.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

contract NFTCollectionsTest is Test, IERC721Receiver {
    NFTCollections nftCollections;
    address owner;

    function setUp() public {
        owner = address(this);
        nftCollections = new NFTCollections("TestNFT", "TNFT");
    }

    function onERC721Received(
        address,
        address,
        uint256,
        bytes memory
    ) public pure override returns (bytes4) {
        return IERC721Receiver.onERC721Received.selector;
    }

    function testCreateCollection() public {
        vm.prank(owner);
        nftCollections.createCollection("My Collection");
        NFTCollections.Collection[] memory collections = nftCollections.getAllCollections();
        assertEq(collections.length, 1);
        assertEq(collections[0].name, "My Collection");
        assertEq(collections[0].owner, owner);
    }

    function testCreateToken() public {
        vm.prank(owner);
        nftCollections.createCollection("My Collection");
        uint256 collectionId = 1;
        vm.prank(owner);
        nftCollections.createToken(collectionId, "https://token-uri.com");
        NFTCollections.ListedToken[] memory tokens = nftCollections.getTokensInCollection(collectionId);
        assertEq(tokens.length, 1);
        assertEq(tokens[0].tokenId, 1);
        assertEq(tokens[0].collectionId, collectionId);
        assertEq(tokens[0].owner, address(this));
    }

    function testFailCreateTokenWithoutOwnership() public {
        vm.prank(owner);
        nftCollections.createCollection("My Collection");
        uint256 collectionId = 1;
        address nonOwner = address(0x123);
        vm.prank(nonOwner);
        nftCollections.createToken(collectionId, "https://token-uri.com");
    }

    function testGetMyCollections() public {
        vm.prank(owner);
        nftCollections.createCollection("Collection One");
        vm.prank(owner);
        nftCollections.createCollection("Collection Two");

        address other = address(0x2);
        vm.startPrank(other);
        nftCollections.createCollection("Other's Collection");
        vm.stopPrank();

        NFTCollections.Collection[] memory myCollections = nftCollections.getMyCollections();
        assertEq(myCollections.length, 2);
        assertEq(myCollections[0].name, "Collection One");
        assertEq(myCollections[1].name, "Collection Two");
    }
}
