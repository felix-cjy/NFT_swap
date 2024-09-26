// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/NFTswap.sol";

contract DeployNFTswap is Script {
    function run() external {
        // Use the first account provided by Anvil
        uint256 deployerPrivateKey = 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;

        vm.startBroadcast(deployerPrivateKey);

        NFTswap nftSwap = new NFTswap();

        vm.stopBroadcast();

        console.log("NFTswap deployed to:", address(nftSwap));
    }
}
