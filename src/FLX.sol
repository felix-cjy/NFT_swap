// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract FLX is ERC721, Ownable {
    uint256 private _tokenIds;

    constructor() ERC721("FLX", "FLX") Ownable(msg.sender) {
        _tokenIds = 0;
    }

    function mint(address to) public onlyOwner returns (uint256) {
        _tokenIds++;
        uint256 newTokenId = _tokenIds;
        _safeMint(to, newTokenId);
        return newTokenId;
    }

    function getCounter() external view returns (uint256){
        return _tokenIds;
    }
}
