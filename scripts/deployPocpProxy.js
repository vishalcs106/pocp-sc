//deployment script for tykto mart

const hre = require("hardhat");

async function main() {
  const PocpProxy = await hre.ethers.getContractFactory("PocpProxy");
  const pocpProxy = await hre.upgrades.deployProxy();
  await pocpProxy.deployed();

  console.log("PocpProxy deployed to:", pocpProxy.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });