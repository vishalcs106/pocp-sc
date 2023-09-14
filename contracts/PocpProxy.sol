// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import "@openzeppelin/contracts/proxy/Clones.sol";
import "./PocpImplementation.sol";
import "./Error.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";

contract PocpProxy is
    Initializable,
    ReentrancyGuardUpgradeable,
    PausableUpgradeable,
    OwnableUpgradeable
{
    using Clones for address;
    using Counters for Counters.Counter;
    Counters.Counter private idCounter;

    address public pocpImplementationAddress;
    mapping(uint256 => Poc) public pocMapping;
    uint256 public creationFee;

    constructor(address _pocpImplementationAddress) {
        pocpImplementationAddress = _pocpImplementationAddress;
        idCounter.increment();
    }

    event PocContractCreated(address contractAddress);
    event CreationFeeSet(uint256 creationFee);

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    struct Poc {
        uint256 id;
        address owner;
        address contractAddress;
    }

    function createPoc(
        string memory _name,
        string memory _symbol
    ) external payable whenNotPaused nonReentrant {
        if (msg.value != creationFee) {
            revert InvalidFee();
        }
        address clonedAddress = pocpImplementationAddress.clone();
        PocpImplementation(clonedAddress).initialize(_name, _symbol);
        Poc memory poc = Poc(idCounter.current(), msg.sender, clonedAddress);
        pocMapping[idCounter.current()] = poc;
        emit PocContractCreated(clonedAddress);
    }

    function setCreationFee(uint256 _creationFee) external onlyOwner {
        creationFee = _creationFee;
        emit CreationFeeSet(_creationFee);
    }
}
