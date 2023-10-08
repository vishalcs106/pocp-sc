// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

contract DataTypes {
    struct PocNft {
        address contractAddress;
        uint256 tokenId;
    }

    struct Poc {
        uint256 id;
        address owner;
        address contractAddress;
        uint256 createdAt;
        string startDate;
        string endDate;
        bool verified;
    }
}
