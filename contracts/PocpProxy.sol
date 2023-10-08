// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

import "@openzeppelin/contracts/proxy/Clones.sol";

import "./Error.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "./PocpImplementation.sol";
import "./IPocpRegistry.sol";
import "./DataTypes.sol";

contract PocpProxy is
    Initializable,
    ReentrancyGuardUpgradeable,
    PausableUpgradeable,
    OwnableUpgradeable,
    UUPSUpgradeable
{
    using Clones for address;
    using Counters for Counters.Counter;
    Counters.Counter private idCounter;

    address public pocpImplementationAddress;
    address public pocpRegistryAddress;
    uint256 public creationFee;

    function initialize(
        address _pocpImplementationAddress,
        address _pocpRegistryAddress
    ) public initializer {
        __ReentrancyGuard_init();
        __Pausable_init();
        __Ownable_init();
        __UUPSUpgradeable_init();
        pocpRegistryAddress = _pocpRegistryAddress;
        pocpImplementationAddress = _pocpImplementationAddress;
        creationFee = 0.001 ether;
        idCounter.increment();
    }

    event PocContractCreated(address contractAddress);
    event CreationFeeSet(uint256 creationFee);

    function _authorizeUpgrade(address) internal virtual override onlyOwner {}

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function createPoc(
        string memory _name,
        string memory _symbol,
        string memory _startDate,
        string memory _endDate
    ) external payable whenNotPaused nonReentrant {
        if (msg.value != creationFee) {
            revert InvalidFee();
        }
        address clonedAddress = pocpImplementationAddress.clone();
        PocpImplementation(clonedAddress).initialize(_name, _symbol);
        DataTypes.Poc memory poc = DataTypes.Poc(
            idCounter.current(),
            msg.sender,
            clonedAddress,
            block.timestamp,
            _startDate,
            _endDate,
            false
        );
        IPocpRegistry iPocpRegistry = IPocpRegistry(pocpRegistryAddress);
        iPocpRegistry.savePoc(poc);
        idCounter.increment();
        emit PocContractCreated(clonedAddress);
    }

    function setCreationFee(uint256 _creationFee) external onlyOwner {
        creationFee = _creationFee;
        emit CreationFeeSet(_creationFee);
    }
}
