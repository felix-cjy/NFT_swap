// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/NFTswap.sol";
import "./FLX.sol";

contract NFTswapIntegrationTest is Test {
    NFTswap public nftSwap;
    FLX public flx;
    address public alice = address(0x1);
    address public bob = address(0x2);
    address public charlie = address(0x3);

    function setUp() public {
        nftSwap = new NFTswap();
        flx = new FLX();
        vm.deal(alice, 10 ether);
        vm.deal(bob, 10 ether);
        vm.deal(charlie, 10 ether);
    }

    function testFullFlow() public {
        // Alice mints and lists an NFT
        uint256 tokenId1 = flx.mint(alice);
        vm.startPrank(alice);
        flx.approve(address(nftSwap), tokenId1);
        nftSwap.list(address(flx), tokenId1, 1 ether);
        vm.stopPrank();

        // Bob mints and lists an NFT
        uint256 tokenId2 = flx.mint(bob);
        vm.startPrank(bob);
        flx.approve(address(nftSwap), tokenId2);
        nftSwap.list(address(flx), tokenId2, 2 ether);
        vm.stopPrank();

        // Charlie buys Alice's NFT
        vm.prank(charlie);
        nftSwap.purchase{value: 1 ether}(address(flx), tokenId1);

        // Alice updates the price of Bob's NFT (which should fail)
        vm.expectRevert(NFTswap.NotOwner.selector);
        vm.prank(alice);
        nftSwap.update(address(flx), tokenId2, 3 ether);

        // Bob updates the price of his NFT
        vm.prank(bob);
        nftSwap.update(address(flx), tokenId2, 3 ether);

        // Charlie tries to buy Bob's NFT with insufficient funds (which should fail)
        vm.expectRevert(NFTswap.NotEnoughMoney.selector);
        vm.prank(charlie);
        nftSwap.purchase{value: 2 ether}(address(flx), tokenId2);

        // Charlie buys Bob's NFT with correct funds
        vm.prank(charlie);
        nftSwap.purchase{value: 3 ether}(address(flx), tokenId2);

        // Assert final state
        assertEq(flx.ownerOf(tokenId1), charlie);
        assertEq(flx.ownerOf(tokenId2), charlie);
        assertEq(alice.balance, 11 ether);
        assertEq(bob.balance, 13 ether);
        assertEq(charlie.balance, 6 ether);
    }
}
