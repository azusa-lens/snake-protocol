const hre = require("hardhat");

async function main() {
  console.log("Deploying SNAKE Game contract to", hre.network.name);

  const [deployer] = await hre.ethers.getSigners();
  console.log("Deploying with:", deployer.address);
  console.log("Balance:", hre.ethers.formatEther(await hre.ethers.provider.getBalance(deployer.address)), "ETH");

  const SnakeGame = await hre.ethers.getContractFactory("SnakeGame");
  const snake = await SnakeGame.deploy();
  await snake.waitForDeployment();

  const address = await snake.getAddress();
  console.log("\n✅ SnakeGame deployed to:", address);
  console.log("🔍 Explorer:", hre.network.name === "base"
    ? `https://basescan.org/address/${address}`
    : `https://sepolia.basescan.org/address/${address}`
  );
  console.log("\nAdd to snake_game.html:");
  console.log(`const CONTRACT_ADDRESS = "${address}";`);
}

main().catch(e => { console.error(e); process.exit(1); });
