const hre = require("hardhat");

async function main() {
  console.log("Deploying Voting contract...");

  const Voting = await hre.ethers.getContractFactory("Voting");
  const voting = await Voting.deploy();
  await voting.waitForDeployment();

  const address = await voting.getAddress();
  console.log(`Voting deployed to: ${address}`);

  // Add sample candidates
  console.log("Adding candidates...");
  await voting.addCandidate("Alice Johnson", "Progressive Party");
  await voting.addCandidate("Bob Smith", "National Party");
  await voting.addCandidate("Carol White", "Liberty Party");

  console.log("Candidates added.");
  console.log("\nCopy this address into frontend/app.js CONTRACT_ADDRESS:");
  console.log(address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
