// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
// import "@openzeppelin/contracts/utils/Counters.sol"; // This was removed in OZ v5, keep it commented

contract MyNFTCollection is ERC721URIStorage, Ownable {
    // Manually manage the next token ID for minting from your fixed collection
    uint256 private _nextTokenId;

    // Stores the IPFS CIDs for your metadata JSON files
    string[] public baseURIs;

    // Struct to hold listing details
    struct Listing {
        address seller;
        uint256 price;
        bool isListed;
    }

    // Mapping from tokenId to Listing struct
    mapping(uint256 => Listing) public listings;

    // Events to notify off-chain applications about marketplace activity
    event NFTListed(uint256 indexed tokenId, address indexed seller, uint256 price);
    event NFTSold(uint256 indexed tokenId, address indexed seller, address indexed buyer, uint256 price);
    event ListingCancelled(uint256 indexed tokenId, address indexed seller);

    constructor(string memory name, string memory symbol, string[] memory _baseURIs)
        ERC721(name, symbol)
        Ownable(msg.sender)
    {
        // Store the pre-defined base URIs
        for (uint i = 0; i < _baseURIs.length; i++) {
            baseURIs.push(_baseURIs[i]);
        }
        _nextTokenId = 0; // Initialize the counter for the first NFT (Token ID 0)
    }

    // ---------------------------------------------------------------------
    // NFT Minting Functionality
    // ---------------------------------------------------------------------
    /**
     * @dev Mints a new NFT from the predefined collection.
     * Only the contract owner can call this function.
     * @param to The address to mint the NFT to.
     */
    function mintNFT(address to) public onlyOwner {
        uint256 newItemId = _nextTokenId;

        require(newItemId < baseURIs.length, "No more NFTs to mint in this collection.");

        _safeMint(to, newItemId); // Mints the NFT and assigns ownership
        _setTokenURI(newItemId, baseURIs[newItemId]); // Assigns the metadata URI

        _nextTokenId++; // Increment for the next NFT
    }

    /**
     * @dev Returns the base URI of a specific token ID.
     * @param tokenId The ID of the token to query.
     */
    function getTokenBaseURI(uint256 tokenId) public view returns (string memory) {
        // In OZ v5.x, _ownerOf(tokenId) != address(0) is used to check existence
        require(_ownerOf(tokenId) != address(0), "ERC721: token query for nonexistent token");
        require(tokenId < baseURIs.length, "Invalid token ID for base URI lookup");
        return baseURIs[tokenId];
    }

    // ---------------------------------------------------------------------
    // Marketplace Functionality
    // ---------------------------------------------------------------------

    /**
     * @dev Lists an NFT for sale on the marketplace.
     * Requires the seller to own the NFT and have approved this contract.
     * @param tokenId The ID of the NFT to list.
     * @param price The price in wei (e.g., 1000000000000000000 wei = 1 ETH).
     */
    function listNFT(uint256 tokenId, uint256 price) public {
        require(_ownerOf(tokenId) == msg.sender, "ERC721Market: Caller is not the owner of the NFT.");
        require(price > 0, "ERC721Market: Price must be greater than 0.");
        // Ensure the marketplace contract is approved to transfer this NFT
        // getApproved(tokenId) returns the address approved for this token.
        // It should be 'address(this)' (this contract's address).
        require(getApproved(tokenId) == address(this), "ERC721Market: NFT not approved for marketplace transfer.");

        listings[tokenId] = Listing(msg.sender, price, true); // Store listing details
        emit NFTListed(tokenId, msg.sender, price); // Emit event
    }

    /**
     * @dev Buys an NFT from the marketplace.
     * @param tokenId The ID of the NFT to buy.
     */
    function buyNFT(uint256 tokenId) public payable {
        Listing storage listing = listings[tokenId]; // Get listing details

        require(listing.isListed, "ERC721Market: NFT not currently listed for sale.");
        require(msg.value == listing.price, "ERC721Market: Sent ETH does not match listing price.");
        require(listing.seller != address(0), "ERC721Market: Seller address is invalid.");
        require(listing.seller != msg.sender, "ERC721Market: Cannot buy your own NFT.");

        // Transfer NFT to the buyer (msg.sender)
        _transfer(listing.seller, msg.sender, tokenId);

        // Transfer funds to the seller
        payable(listing.seller).transfer(msg.value);

        // Remove listing after sale
        delete listings[tokenId]; // Reset the struct for this tokenId
        emit NFTSold(tokenId, listing.seller, msg.sender, listing.price); // Emit event
    }

    /**
     * @dev Cancels an active listing.
     * Only the seller of the NFT can cancel their listing.
     * @param tokenId The ID of the NFT to cancel the listing for.
     */
    function cancelListing(uint256 tokenId) public {
        Listing storage listing = listings[tokenId];

        require(listing.isListed, "ERC721Market: NFT not currently listed.");
        require(listing.seller == msg.sender, "ERC721Market: Caller is not the seller of this listing.");

        delete listings[tokenId]; // Remove listing
        emit ListingCancelled(tokenId, msg.sender); // Emit event
    }





    function redeem(uint256 shares, address receiver, address owner) external returns (uint256 assets)












    function withdraw(uint256 assets, address receiver, address owner) external returns (uint256 shares)





    function mint(uint256 shares, address receiver) external returns (uint256 assets)






    function deposit(uint256 assets, address receiver) external returns (uint256 shares)

    function convertToShares(uint256 assets) external view returns (uint256 shares)


    function convertToAssets(uint256 shares) external view returns (uint256 assets)





    function totalAssets() external view returns (uint256 totalManagedAssets)




    function asset() external view returns (address assetTokenAddress)


function totalAssets() external view returns (uint256 totalManagedAssets)

function convertToAssets(uint256 shares) external view returns (uint256 assets)
function convertToShares(uint256 assets) external view returns (uint256 shares)




function deposit(uint256 assets, address receiver) external returns (uint256 shares)


function mint(uint256 shares, address receiver) external returns (uint256 assets)


function withdraw(uint256 assets, address receiver, address owner) external returns (uint256 shares)


function redeem(uint256 shares, address receiver, address owner) external returns (uint256 assets)



















}
