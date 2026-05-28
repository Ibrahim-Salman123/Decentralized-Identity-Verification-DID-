# IdentityRegistry Smart Contract

A decentralized Identity Management (DID) and verification registry built on Ethereum using Solidity. This contract allows authorized verifiers to securely register, manage, and revoke user identities mapped to encrypted IPFS payloads.

---

## 📌 Overview

The **IdentityRegistry** smart contract provides a decentralized framework for identity verification. Instead of storing sensitive Personally Identifiable Information (PII) directly on-chain, it maps user addresses to secure, off-chain encrypted IPFS metadata hashes. The contract operates on a trust network where a contract `owner` manages `authorizedVerifiers`, who in turn validate and manage user identity lifecycles.

---

## 🛠 Features

* **Privacy-Focused Identity Mapping:** Stores cryptographic IPFS hashes containing encrypted user data on-chain, keeping raw sensitive data private and off the public ledger.
* **Granular Role Management:** Implements dynamic authorization for system validators via `authorizedVerifiers` mapping.
* **On-Chain Lifecycle Tracking:** Full support for registering, updating, and revoking identities dynamically based on real-time assessments.
* **Strict Public Access Restraints:** The data retrieval engine strictly blocks data lookups for identities that have been revoked or are unregistered.

---

## 📄 Smart Contract Architecture

### Data Structures

#### `Identity` (Struct)
Tracks individual verification states:
* `ipfsHash`: A cryptographic string pointing to the encrypted off-chain identity documents on IPFS.
* `updatedTimestamp`: The exact block timestamp marking when the identity was last updated or registered.
* `isValid`: A boolean flag validating whether the identity is currently active.
* `verifier`: The Ethereum wallet address of the authorized validator who registered the identity record.

### State Variables
* `owner`: The address of the platform administrator (contract deployer) possessing exclusive access to change verifier statuses.
* `registries`: A private mapping linking individual user addresses to their corresponding `Identity` configurations.
* `authorizedVerifiers`: A public mapping (`verifierAddress => bool`) identifying verified ecosystem nodes.

---

## ⚙️ Core Functions

#### 1. `setVerifierStatus(address _verifier, bool _status)`
* **Permission:** Only `owner`
* **Description:** Activates or deactivates the operational status of an identity validator.

#### 2. `registerIdentity(address _user, string calldata _ipfsHash)`
* **Permission:** Only `authorizedVerifiers`
* **Description:** Compiles and maps a validated cryptographic identifier to a user's address, logging the operational time and validating node data.

#### 3. `revokeIdentity(address _user)`
* **Permission:** Only `authorizedVerifiers`
* **Description:** Implements dynamic offboarding by marking the target user's identity structural validation state as `false`.

#### 4. `getIdentity(address _user)`
* **Permission:** Public View (Free to call)
* **Description:** External query engine that returns the active identity payload mapping. Rejects transactions instantly if the target identity is revoked or non-existent.

---

## 🔔 Events

* `IdentityUpdated(address indexed user, string ipfsHash, address indexed verifier)`: Emitted when an identity is newly created or adjusted.
* `IdentityRevoked(address indexed user, address indexed verifier)`: Emitted upon successful cancellation of active identity statuses.
* `VerifierStatusChanged(address indexed verifier, bool status)`: Emitted when administrative updates alter system authorization structures.

---

## 🚀 Tech Stack & Setup

* **Language:** Solidity `^0.8.20`
* **Tools:** Remix IDE / Hardhat / Foundry

### Standard Deploy Instructions

1. Launch **Remix IDE**.
2. Create a contract file named `IdentityRegistry.sol` and paste the codebase.
3. Target compilation with compiler version set to `0.8.20`.
4. Execute deployment. The account used during deployment automatically registers as the default `owner` and first `authorizedVerifier`.

---

## ⚖️ License

This project is licensed under the **MIT License**.
