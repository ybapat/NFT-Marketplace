const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);

  const name = "Guitar NFT Collection";
  const symbol = "YSBGT";


  const metadataURIs = [
    "ipfs://bafkreihfaimpkvpkxwxtg7qspifflmzslc2yat3q6tm57d3egoygullhqe", // CID for NFT #1 metadata
    "ipfs://bafkreifv4d2jhhfw767ffskqaq3otu4virknudq2okbmzp4hky6wni7veu", // CID for NFT #2 metadata
    "ipfs://bafkreib4npnzsmbwle24dorc3mcr73jrcxckb6dt4miue36fixcv5iseja",  // CID for NFT #3 metadata
    "ipfs://bafkreie3fariiezbistghudqbmjgtwtlsllbknbxe3rlkn7lzd2xmy6ivm"  // CID for NFT #4 metadata

  ];

  const MyNFTCollection = await hre.ethers.getContractFactory("MyNFTCollection");
  const myNftCollection = await MyNFTCollection.deploy(name, symbol, metadataURIs);

  await myNftCollection.waitForDeployment();

  console.log("MyNFTCollection deployed to:", myNftCollection.target);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });