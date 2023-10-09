//deployment script for tykto mart

const hre = require("hardhat");

async function main() {
  const PocpProxy = await hre.ethers.getContractFactory("PocpProxy");
  const pocpProxy = await hre.upgrades.deployProxy(PocpProxy, [
    "0x41B22dCd1aC25b478c6207cC2335d2319A0F71d5",
    "0xd3B077C4B7971aeBa4251274135615957f268bE5",
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
