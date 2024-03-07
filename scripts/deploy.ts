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
// goerli 0x3cdd2e241da1c993f0cbd74a39e56b18cd0287fc
// goerli 0x0344d77f879b7f50397e33d627088fbe424fac5a
// transaction test: https://goerli.etherscan.io/tx/0x960e6d5483f93af1df53c2b4b67a0a22b55efc54273aeadf4ff36273623cb614
//goerli 0x5508e60f8d1140c1deabca80cb143f19d88cc2f4

//base deployment: 0xef39827c004984b8b48c68d0535e774eeb7adcfa
