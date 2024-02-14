import { formatEther, parseEther } from "viem";
import hre from "hardhat";

async function main() {
  const FrameSwapDegen = await hre.viem.deployContract(
    "FrameSwapDegen" /*, [unlockTime], {
    value: lockedAmount,
  }*/
  );

  console.log(`deployed to ${FrameSwapDegen.address}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
