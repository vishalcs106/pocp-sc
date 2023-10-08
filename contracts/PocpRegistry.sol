// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;
import "./DataTypes.sol";
import "./IPocpRegistry.sol";

contract PocpRegistry is IPocpRegistry {
    mapping(address => DataTypes.PocNft[]) public pocpRegistry;
    mapping(address => DataTypes.Poc) public pocMapping;
    mapping(address => address) public pocOwnerMapping;

    function addPocp(
        address _owner,
        address _contractAddress,
        uint256 _tokenId
    ) public {
        DataTypes.PocNft memory newPocp = DataTypes.PocNft({
            contractAddress: _contractAddress,
            tokenId: _tokenId
        });

        pocpRegistry[_owner].push(newPocp);
    }

    function getPocpCount(address _owner) public view returns (uint256) {
        return pocpRegistry[_owner].length;
    }

    function getPocpByIndex(
        address _owner,
        uint256 index
    ) public view returns (address, uint256) {
        require(index < getPocpCount(_owner), "Index out of bounds");
        DataTypes.PocNft memory pocp = pocpRegistry[_owner][index];
        return (pocp.contractAddress, pocp.tokenId);
    }

    function removePocp(address _owner, uint256 index) public {
        require(index < getPocpCount(_owner), "Index out of bounds");
        if (index != pocpRegistry[_owner].length - 1) {
            DataTypes.PocNft storage pocpToRemove = pocpRegistry[_owner][index];
            DataTypes.PocNft storage lastPocp = pocpRegistry[_owner][
                pocpRegistry[_owner].length - 1
            ];
            (pocpToRemove.contractAddress, pocpToRemove.tokenId) = (
                lastPocp.contractAddress,
                lastPocp.tokenId
            );
        }
        pocpRegistry[_owner].pop();
    }

    function savePoc(DataTypes.Poc calldata poc) public {
        pocMapping[poc.contractAddress] = poc;
        pocOwnerMapping[msg.sender] = poc.contractAddress;
    }
}