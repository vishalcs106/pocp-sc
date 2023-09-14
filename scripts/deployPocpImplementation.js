//deployment script for tykto mart

const hre = require("hardhat");

async function main() {
  const PocpImplementation = await hre.ethers.getContractFactory("PocpImplementation");
  const pocpImplementation = await hre.upgrades.deployProxy(PocpImplementation,["POCP", "POC"]);
  await pocpImplementation.deployed();

  console.log("PocpImplementation deployed to:", pocpImplementation.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });