// contracts/GameItems.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

contract NFTTrade
{
    struct Listing{
        address seller;
        uint256 price;
        uint256 amount;
    }

    mapping (address => uint256) public balance;

    mapping (address => mapping (uint256 => Listing)) public listings;

    function addListing (address tokenContr, uint256 tokenId,  uint256 amount, uint256 price) public
    {
        require(amount > 0, "Need more then zero");
        ERC1155 token = ERC1155(tokenContr);
        require(token.balanceOf(msg.sender, tokenId) >= amount, "Do not enough token on your wallet");
        require(token.isApprovedForAll(msg.sender, address(this)), "Don`t approve wallet"); 
        require(listings[msg.sender][tokenId].amount == 0, "You already list this NFT");

        listings[tokenContr][tokenId] = Listing(msg.sender, price, amount);
    }

    function purchase(address tokenContr, uint256 tokenId, uint256 amount) public payable {
        Listing memory item = listings[tokenContr][tokenId];

        require(item.amount >= amount, "Do not have enough token in store");
        require(msg.value >= item.price * amount, "Don`t have enouch money in contract");

        ERC1155 token = ERC1155(tokenContr);
        token.safeTransferFrom(item.seller, msg.sender, tokenId, amount, "");

        balance[item.seller] += item.price * amount; // надо ли msg.value
        listings[tokenContr][tokenId].amount -= amount;
    }

    function withdrow(address payable destAddr, uint256 amount) public 
    {
        require(balance[msg.sender] >= amount, "Don`t have enough money on balance");
        
        destAddr.transfer(amount);

        balance[msg.sender] -= amount;
    }
}