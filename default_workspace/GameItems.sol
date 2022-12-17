// contracts/GameItems.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract GameItems is ERC1155 {
    uint256 public constant Rock = 0;
    uint256 public constant Paper = 1;
    uint256 public constant Scissors = 2;

    constructor() public ERC1155("https://gateway.pinata.cloud/ipfs/QmbbUGBSfH2VXK5DXmxyP21vgVfKQui7paEg58pWj1PCEL/{id}.json") {
        _mint(msg.sender, Rock, 100, "");
        _mint(msg.sender, Paper, 100, "");
        _mint(msg.sender, Scissors, 100, "");
    }

    function uri(uint256 _tokenid) override public pure returns (string memory) {
        return string(
            abi.encodePacked(
                "https://gateway.pinata.cloud/ipfs/QmbbUGBSfH2VXK5DXmxyP21vgVfKQui7paEg58pWj1PCEL/",
                Strings.toString(_tokenid),".json"
            )
        );
    }
}