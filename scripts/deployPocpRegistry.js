//deployment script for tykto mart

const hre = require("hardhat");

async function main() {
  const PocpRegistry = await hre.ethers.getContractFactory("PocpRegistry");
  const pocpRegistry = await hre.upgrades.deployProxy(PocpRegistry);
  await pocpRegistry.deployed();

  console.log("PocpRegistry deployed to:", pocpRegistry.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
