// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/MyNFT.sol";

contract MyNFTTest is Test {
    MyNFT myNft;
    address recipient = address(0x1);

    function setUp() public {
        myNft = new MyNFT();
    }

    function testCreateNFT() public {
        uint256 tokenId = myNft.createNFT(recipient, "tokenURI");
        assertEq(myNft.ownerOf(tokenId), recipient);

    }
}

