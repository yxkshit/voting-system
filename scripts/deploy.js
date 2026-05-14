const hre = require("hardhat");

async function main() {
  console.log("Deploying Voting contract...");

  const Voting = await hre.ethers.getContractFactory("Voting");
  const voting = await Voting.deploy();
  await voting.waitForDeployment();

  const address = await voting.getAddress();
  console.log(`Voting deployed to: ${address}`);
  console.log("\nCopy this address into frontend/app.js CONTRACT_ADDRESS:");
  console.log(address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
