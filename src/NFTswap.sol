/* task要求
用solidity实现一个零手续费的去中心化 NFT 交易所，主要逻辑：
- 卖家：出售 NFT 的一方，可以挂单 list、撤单 revoke、修改价格 update。
- 买家：购买 NFT 的一方，可以购买 purchase
- 订单：卖家发布的 NFT 链上订单，一个系列的同一 tokenId 最多存在一个订单，
其中包含挂单价格 price 和持有人 owner 信息。当一个订单交易完成或被撤单后，其中信息清零。
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import {IERC721Receiver} from "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

// 此交易所为托管制,需要接收NFT
contract NFTswap is IERC721Receiver {
    struct Order {
        address owner;
        uint256 price;
    }

    mapping(address => mapping(uint256 => Order)) public orders;

    error NotApproved();
    error NotEnoughMoney();
    error NotOwner();
    error InvalidOrder();

    event List(address indexed seller, address indexed nftAddr, uint256 indexed tokenId, uint256 price);
    event Revoke(address indexed seller, address indexed nftAddr, uint256 indexed tokenId);
    event Update(address indexed seller, address indexed nftAddr, uint256 indexed tokenId, uint256 price);
    event Purchase(address indexed buyer, address indexed nftAddr, uint256 indexed tokenId, uint256 price);

    constructor() {}

    function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data)
        external
        override
        returns (bytes4)
    {
        return IERC721Receiver.onERC721Received.selector;
    }

    receive() external payable {}

    fallback() external payable {}

    // 挂单
    function list(address _nftAddr, uint256 _tokenId, uint256 _price) public {
        IERC721 _nft = IERC721(_nftAddr);

        if (_nft.getApproved(_tokenId) != address(this)) {
            revert NotApproved();
        }
        require(_price > 0, "Price Error");

        Order storage _order = orders[_nftAddr][_tokenId];
        _order.owner = msg.sender;
        _order.price = _price;

        _nft.safeTransferFrom(msg.sender, address(this), _tokenId);

        emit List(msg.sender, _nftAddr, _tokenId, _price);
    }

    // 撤单
    function revoke(address _nftAddr, uint256 _tokenId) public {
        Order storage _order = orders[_nftAddr][_tokenId];
        if (_order.owner != msg.sender) {
            revert NotOwner();
        }

        IERC721 _nft = IERC721(_nftAddr);
        if (_nft.ownerOf(_tokenId) != address(this)) {
            revert InvalidOrder();
        }

        _nft.safeTransferFrom(address(this), msg.sender, _tokenId);
        delete orders[_nftAddr][_tokenId];

        emit Revoke(msg.sender, _nftAddr, _tokenId);
    }

    // 改价
    function update(address _nftAddr, uint256 _tokenId, uint256 _newPrice) public {
        require(_newPrice > 0);
        Order storage _order = orders[_nftAddr][_tokenId];
        if (_order.owner != msg.sender) {
            revert NotOwner();
        }

        IERC721 _nft = IERC721(_nftAddr);
        if (_nft.ownerOf(_tokenId) != address(this)) {
            revert InvalidOrder();
        }

        _order.price = _newPrice;

        emit Update(msg.sender, _nftAddr, _tokenId, _newPrice);
    }

    // 购买
    function purchase(address _nftAddr, uint256 _tokenId) public payable {
        Order storage _order = orders[_nftAddr][_tokenId];
        if (msg.value < _order.price) {
            revert NotEnoughMoney();
        }

        IERC721 _nft = IERC721(_nftAddr);
        if (_nft.ownerOf(_tokenId) != address(this)) {
            revert InvalidOrder();
        }

        _nft.safeTransferFrom(address(this), msg.sender, _tokenId);
        payable(_order.owner).transfer(_order.price);
        payable(msg.sender).transfer(msg.value - (_order.price));

        delete orders[_nftAddr][_tokenId];

        emit Purchase(msg.sender, _nftAddr, _tokenId, _order.price);
    }

    function getOrder(address _nftAddr, uint256 _tokenId) public view returns (Order memory) {
        return orders[_nftAddr][_tokenId];
    }
}
