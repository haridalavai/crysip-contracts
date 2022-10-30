// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require('hardhat');
const fs = require('fs');

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile');

  // We get the contract to deploy
  const Greeter = await hre.ethers.getContractFactory('Greeter');
  const greeter = await Greeter.deploy('Hello, Hardhat!');

  await greeter.deployed();

  console.log('Greeter deployed to:', greeter.address);

  const CrypotManager = await hre.ethers.getContractFactory('CrypotManager');
  const crypotManager = await CrypotManager.deploy();

  await crypotManager.deployed();

  console.log('CrypotManager', crypotManager.address);

  const Swap = await hre.ethers.getContractFactory('Swap');
  const swap = await Swap.deploy();

  await swap.deployed();

  console.log('Swap', swap.address);

  fs.writeFileSync(
    './config.js',
    `export const CRYPOT_MANAGER = '${crypotManager.address}'
    export const SWAP = '${swap.address}'`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
