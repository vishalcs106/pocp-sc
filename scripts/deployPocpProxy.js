//deployment script for tykto mart

const hre = require("hardhat");

async function main() {
  const PocpProxy = await hre.ethers.getContractFactory("PocpProxy");
  const pocpProxy = await hre.upgrades.deployProxy(PocpProxy, [
    "0x96196BD992Bd39D5039b58486261580DBbe5afDc",
    "0x3e2E96de5320F654114692ba25988269835d563E",
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
