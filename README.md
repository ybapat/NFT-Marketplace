# Jam Jungle NFT Marketplace

> A full-stack, decentralized marketplace for a pre-defined, curated collection of unique digital guitar NFTs, deployed on the Sepolia testnet.

---

## 📖 About This Project

This project is a complete, decentralized NFT marketplace. Unlike an open minting platform, this marketplace is designed for a curated collection of "Jam Jungle" guitars.

The contract owner is responsible for minting the initial set of NFTs (each with unique metadata from IPFS). Once minted and distributed, users can then securely buy, sell, and trade those NFTs in a peer-to-peer fashion.

The core of the project is the `MyNFTCollection.sol` smart contract, which handles both the NFT's existence (ERC721) and the marketplace logic (listing, buying, selling).

---

## ✨ Key Features

* **Curated Collection:** A fixed collection of guitar NFTs, minted only by the contract owner, each with unique metadata assigned at mint time.
* **Atomic & Secure Trading:** The `buyNFT` function ensures that the ETH payment and the NFT transfer happen in a single, atomic transaction.
* **List / Buy / Cancel:** Users can list their owned NFTs for a set price, buy any listed NFT, and cancel their own listings at any time.
* **On-Chain Listing Data:** A `struct` and `mapping` store all listing information (seller, price, status) directly on the blockchain.
* **Decentralized Metadata:** All NFT images and metadata are stored on **IPFS** and linked on-chain.
* **Wallet Integration:** Connects to any web3 wallet (like MetaMask) using **Ethers.js** to manage assets and sign transactions.

---

## 🛠️ Tech Stack

* **Smart Contract:** Solidity
* **Blockchain Dev Environment:** Hardhat (for local testing and deployment)
* **Contract Standards:** OpenZeppelin (for secure `ERC721URIStorage` and `Ownable`)
* **Frontend:** React, Next.js, Ethers.js
* **File Storage:** IPFS (for decentralized hosting of NFT images and metadata)
* **Testnet:** Sepolia

---

## 📖 Marketplace Workflow

For a transaction to occur, a specific flow of operations is required:



1.  **Minting (Owner Only):** The contract owner calls `mintNFT(toAddress)` to mint NFTs from the predefined collection and send them to an address.
2.  **Approve (Seller):** Before a user can list an NFT, they **must** first call the `approve()` function on the NFT contract. This gives the marketplace contract permission to move their NFT on their behalf when a sale occurs.
    * **From:** The NFT Owner (Seller)
    * **Function:** `approve(marketplaceContractAddress, tokenId)`
3.  **List (Seller):** Once approved, the seller calls `listNFT(tokenId, price)` to put it up for sale. The `price` must be in wei.
4.  **Buy (Buyer):** A buyer calls `buyNFT(tokenId)` and sends the *exact* `price` in ETH (wei) with the transaction. The contract then atomically transfers the NFT to the buyer and the ETH to the seller.
5.  **Cancel (Seller):** If the seller changes their mind, they can call `cancelListing(tokenId)` to remove it from sale (as long as it hasn't been sold).

---

## 🚀 Getting Started (Local Setup)

Follow these instructions to get a copy of the project running on your local machine.

### 1. Prerequisites

* Node.js & npm (v18 or higher)
* MetaMask browser extension

### 2. Environment Variables

To deploy and run this project, you will need to create a `.env` file in the root.

SEPOLIA_RPC_URL="Your_Alchemy_or_Infura_Sepolia_RPC_URL" 

PRIVATE_KEY="Your_deployer_wallet_private_key"


### 3. Installation & Running

1.  Clone the repository:
    ```sh
    git clone https://github.com/ybapat/NFT-Marketplace.git
    ```
2.  Install dependencies:
    ```sh
    npm install
    ```
3.  Compile the smart contracts:
    ```sh
    npx hardhat compile
    ```
4.  Deploy the contracts to the Sepolia testnet:
    ```
    npx hardhat run scripts/deploy.js --network sepolia
    ```
5.  Run the frontend application:
    ```sh
    npm run dev
    ```
7.  Open [http://localhost:3000](http://localhost:3000) in your browser.
