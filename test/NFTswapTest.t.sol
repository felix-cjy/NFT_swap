// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/NFTswap.sol";
import "./FLX.sol";

contract NFTswapTest is Test {
    NFTswap public nftSwap;
    FLX public flx;
    address public alice = address(0x1);
    address public bob = address(0x2);

    function setUp() public {
        nftSwap = new NFTswap();
        flx = new FLX();
    }

    function testList() public {
        uint256 tokenId = flx.mint(alice);
        vm.startPrank(alice);
        flx.approve(address(nftSwap), tokenId);
        nftSwap.list(address(flx), tokenId, 1 ether);
        vm.stopPrank();

        (address _owner, uint256 _price) = nftSwap.orders(address(flx), tokenId);
        // 重点难点!!!, 不能NFTswap.Order _order直接接收结构体

        assertEq(_owner, alice);
        assertEq(_price, 1 ether);
        assertEq(flx.ownerOf(tokenId), address(nftSwap));
    }

    function testRevoke() public {
        uint256 tokenId = flx.mint(alice);
        vm.startPrank(alice);
        flx.approve(address(nftSwap), tokenId);
        nftSwap.list(address(flx), tokenId, 1 ether);
        nftSwap.revoke(address(flx), tokenId);
        vm.stopPrank();

        assertEq(flx.ownerOf(tokenId), alice);
    }

    function testUpdate() public {
        uint256 tokenId = flx.mint(alice);
        vm.startPrank(alice);
        flx.approve(address(nftSwap), tokenId);
        nftSwap.list(address(flx), tokenId, 1 ether);
        nftSwap.update(address(flx), tokenId, 2 ether);
        vm.stopPrank();

        (, uint256 _price) = nftSwap.orders(address(flx), tokenId);
        // 重点难点!!!, 不能NFTswap.Order _order直接接收结构体. 用不上的数据不要接收
        assertEq(_price, 2 ether);
    }

    function testPurchase() public {
        uint256 tokenId = flx.mint(alice);
        vm.startPrank(alice);
        flx.approve(address(nftSwap), tokenId);
        nftSwap.list(address(flx), tokenId, 1 ether);
        vm.stopPrank();

        vm.deal(bob, 2 ether);
        vm.prank(bob);
        nftSwap.purchase{value: 1 ether}(address(flx), tokenId);

        assertEq(flx.ownerOf(tokenId), bob);
        assertEq(alice.balance, 1 ether);
    }
}
