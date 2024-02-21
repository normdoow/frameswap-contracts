import * as dotenv from "dotenv";
import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox-viem";

dotenv.config();

const config: HardhatUserConfig = {
  solidity: "0.8.20",
  gasReporter: {
    enabled: true,
    currency: "USD",
  },
  networks: {
    hardhat: {
      accounts: {
        mnemonic:
          process.env.TEST_MNEMONIC ??
          "test test test test test test test test test test test junk",
      },
    },
    base: {
      url: process.env.BASE_GOERLI_URL || "",
      accounts:
        process.env.PRIVATE_KEY !== undefined ? [process.env.PRIVATE_KEY] : [],
    },
    goerli: {
      url: process.env.GOERLI_URL || "",
      accounts:
        process.env.PRIVATE_KEY !== undefined ? [process.env.PRIVATE_KEY] : [],
    },
    "goerli-optimism": {
      url: process.env.OPTIMISM_GOERLI_URL || "",
      accounts:
        process.env.PRIVATE_KEY !== undefined ? [process.env.PRIVATE_KEY] : [],
    },
  },
  etherscan: {
    // Your API key for Etherscan
    // Obtain one at https://etherscan.io/
    apiKey: process.env.ETHERSCAN_API_KEY ?? "",
    // apiKey: {
    //   optimisticEthereum: process.env.ETHERSCAN_API_KEY ?? "",
    //   optimisticGoerli: process.env.ETHERSCAN_API_KEY ?? "",
    // },
  },
};

export default config;
