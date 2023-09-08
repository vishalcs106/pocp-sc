// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721URIStorageUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/IERC721Upgradeable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "./Error.sol";

contract PocpImplementation is OwnableUpgradeable, ERC721URIStorageUpgradeable {
    using Counters for Counters.Counter;
    Counters.Counter private tokenIdCounter;

    function initialize(string memory _name, string memory _symbol) public initializer {
        __ERC721_init(_name, _symbol);
    }

    function mintNFTs(address[] memory _toAddresses, string[] memory _tokenURIArray) external onlyOwner {
        tokenIdCounter.increment();
        require(_toAddresses.length == _tokenURIArray.length, "Array length mismatch");
        for (uint256 i = 0; i < _toAddresses.length; i++) {
            uint256 tokenId = tokenIdCounter.current();
            _mint(_toAddresses[i], tokenId);
            _setTokenURI(tokenId, _tokenURIArray[i]);
            tokenIdCounter.increment();
        }
    }

    function _burn(
        uint256 tokenId
    ) internal onlyOwner override(ERC721URIStorageUpgradeable) {
        super._burn(tokenId);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId,
        uint256 batchSize
    ) internal override {
        onlySoulbound(from, to);
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view override( ERC721URIStorageUpgradeable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }


    function onlySoulbound(address from, address to) internal pure {
        if (from != address(0) && to != address(0)) {
            revert TokenIsSoulbound();
        }
    }
}