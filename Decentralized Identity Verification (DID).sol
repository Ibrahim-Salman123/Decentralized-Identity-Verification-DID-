// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract IdentityRegistry {
    struct Identity {
        string ipfsHash; // Contains encrypted user data
        uint256 updatedTimestamp;
        bool isValid;
        address verifier;
    }

    mapping(address => Identity) private registries;
    mapping(address => bool) public authorizedVerifiers;
    address public owner;

    event IdentityUpdated(address indexed user, string ipfsHash, address indexed verifier);
    event IdentityRevoked(address indexed user, address indexed verifier);
    event VerifierStatusChanged(address indexed verifier, bool status);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    modifier onlyVerifier() {
        require(authorizedVerifiers[msg.sender], "Not an authorized verifier");
        _;
    }

    constructor() {
        owner = msg.sender;
        authorizedVerifiers[msg.sender] = true;
    }

    function setVerifierStatus(address _verifier, bool _status) external onlyOwner {
        authorizedVerifiers[_verifier] = _status;
        emit VerifierStatusChanged(_verifier, _status);
    }

    function registerIdentity(address _user, string calldata _ipfsHash) external onlyVerifier {
        registries[_user] = Identity({
            ipfsHash: _ipfsHash,
            updatedTimestamp: block.timestamp,
            isValid: true,
            verifier: msg.sender
        });
        emit IdentityUpdated(_user, _ipfsHash, msg.sender);
    }

    function revokeIdentity(address _user) external onlyVerifier {
        require(registries[_user].isValid, "Identity already invalid or doesn't exist");
        registries[_user].isValid = false;
        emit IdentityRevoked(_user, msg.sender);
    }

    function getIdentity(address _user) external view returns (string memory ipfsHash, uint256 updatedTimestamp, bool isValid, address verifier) {
        Identity memory id = registries[_user];
        require(id.isValid, "Identity is not valid or registered");
        return (id.ipfsHash, id.updatedTimestamp, id.isValid, id.verifier);
    }
}
