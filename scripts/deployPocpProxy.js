//deployment script for tykto mart

const hre = require("hardhat");

async function main() {
  const PocpProxy = await hre.ethers.getContractFactory("PocpProxy");
  const pocpProxy = await hre.upgrades.deployProxy(PocpProxy, [
    "0x6325Cd9D08301120a8b362C0ABc3837e0FdF1d2c",
    "0x61F1693C2858a74e54c9B288Fb586c9714F3d5A0",
  ]);
  await pocpProxy.deployed();

  console.log("PocpProxy deployed to:", pocpProxy.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
