pragma solidity 0.8.9;

import "./DataTypes.sol";

interface IPocpRegistry {
    function addPocp(
        address _owner,
        address _contractAddress,
        uint256 _tokenId
    ) external;

    function getPocpCount(address _owner) external view returns (uint256);

    function getPocpByIndex(
        address _owner,
        uint256 index
    ) external view returns (address, uint256);

    function removePocp(address _owner, uint256 index) external;

    function savePoc(DataTypes.Poc calldata poc) external;
}
