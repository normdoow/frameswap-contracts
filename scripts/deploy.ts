import { formatEther, parseEther } from "viem";
import hre from "hardhat";

async function main() {
  const owner = "0xe34ddf3971c259e2966ca47d935b9636d3d9fff5";
  const FrameSwapDegen = await hre.viem.deployContract("FrameSwapDegen", [
    owner,
  ]);

  console.log(`deployed to ${FrameSwapDegen.address}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

// goerli 0xa6e3e6e99aa2035bd8e824ab311983b415fe630a
