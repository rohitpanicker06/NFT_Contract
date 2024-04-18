// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/NFTMarketplace.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

contract NFTMarketplaceTest is Test, IERC721Receiver {
    NFTMarketplace marketplace;
    address owner;

    function setUp() public {
        owner = address(this);
        marketplace = new NFTMarketplace("TestNFT", "TNFT");
    }

    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes memory data
    ) public pure override returns (bytes4) {
        return IERC721Receiver.onERC721Received.selector;
    }

    function testCreateToken() public {
        vm.prank(owner);
        uint256 tokenId = marketplace.createToken("https://token-uri.com");
        assertEq(tokenId, 1, "Token ID should be 1");
        NFTMarketplace.ListedToken memory listedToken = marketplace.getListedForTokenId(tokenId);
        assertEq(listedToken.tokenId, tokenId, "Listed token ID should match");
        assertEq(listedToken.owner, owner, "Owner should match the message sender");
    }

    function testFailCreateTokenNotOwner() public {
        vm.prank(address(0x1));
        marketplace.createToken("https://token-uri.com");
    }

    function testGetAllNFTs() public {
        vm.prank(owner);
        uint256 tokenId1 = marketplace.createToken("https://token-uri.com/1");
        vm.prank(owner);
        uint256 tokenId2 = marketplace.createToken("https://token-uri.com/2");
        NFTMarketplace.ListedToken[] memory tokens = marketplace.getAllNFTs();
        assertEq(tokens.length, 2, "Should list two tokens");
        assertEq(tokens[0].tokenId, tokenId1, "First token ID should match");
        assertEq(tokens[1].tokenId, tokenId2, "Second token ID should match");
    }

    function testGetMyNFTs() public {
        vm.startPrank(owner);
        marketplace.createToken("https://token-uri.com/1");
        vm.stopPrank();

        address anotherUser = address(0x2);
        vm.startPrank(anotherUser);
        vm.expectRevert("Owner can only create token");
        marketplace.createToken("https://token-uri.com/2");
        vm.stopPrank();

        vm.startPrank(owner);
        NFTMarketplace.ListedToken[] memory myTokens = marketplace.getMyNFTs();
        assertEq(myTokens.length, 1, "Should only list owner's tokens");
        assertEq(myTokens[0].tokenId, 1, "Token ID should match");
        vm.stopPrank();
    }



    function testGetCurrentTokenId() public {
        assertEq(marketplace.getCurrentToken(), 0, "Initial token count should be 0");
        vm.prank(owner);
        marketplace.createToken("https://token-uri.com/1");
        assertEq(marketplace.getCurrentToken(), 1, "Token count should be 1 after creation");
    }
}
