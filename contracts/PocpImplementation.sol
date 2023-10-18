// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721URIStorageUpgradeable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./Error.sol";
import "./IPocpRegistry.sol";
import "./DataTypes.sol";

contract PocpImplementation is
    Initializable,
    OwnableUpgradeable,
    ERC721URIStorageUpgradeable
{
    using Counters for Counters.Counter;
    Counters.Counter private tokenIdCounter;

    function initialize(
        string memory _name,
        string memory _symbol
    ) public initializer {
        __ERC721_init(_name, _symbol);
        __Ownable_init();
        transferOwnership(tx.origin);
    }

    function getCurrentSupply() public view returns (uint256) {
        return tokenIdCounter.current();
    }

    function mintNFTs(
        address[] memory _toAddresses,
        string[] memory _tokenURIArray,
        address _pocpRegistryAddress
    ) external onlyOwner {
        require(
            _toAddresses.length == _tokenURIArray.length,
            "Array length mismatch"
        );
        IPocpRegistry iPocpRegistry = IPocpRegistry(_pocpRegistryAddress);
        for (uint256 i = 0; i < _toAddresses.length; i++) {
            uint256 tokenId = tokenIdCounter.current();
            _mint(_toAddresses[i], tokenId);
            iPocpRegistry.addPocp(_toAddresses[i], address(this), tokenId);
            _setTokenURI(tokenId, _tokenURIArray[i]);
            tokenIdCounter.increment();
        }
    }

    function _burn(
        uint256 _tokenId,
        uint256 _index,
        address _pocpRegistryAddress
    ) internal override(ERC721URIStorageUpgradeable) onlyOwner {
        IPocpRegistry iPocpRegistry = IPocpRegistry(_pocpRegistryAddress);
        address holder = ownerOf(tokenId);
        iPocpRegistry.removePocp(holder, index);
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
    ) public view override(ERC721URIStorageUpgradeable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function onlySoulbound(address from, address to) internal pure {
        if (from != address(0) && to != address(0)) {
            revert TokenIsSoulbound();
        }
    }
}
