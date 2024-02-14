// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "hardhat/console.sol";
import "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);

    function transfer(
        address recipient,
        uint256 amount
    ) external returns (bool);

    function approve(address spender, uint256 amount) external returns (bool);
}

contract FrameSwapDegen {
    address public constant routerAddress =
        0x3fC91A3afd70395Cd496C647d5a6CC9D4B2b7FAD; // base router: 0x2626664c2603336E57B271c5C0b26F421741e481;
    ISwapRouter public immutable swapRouter = ISwapRouter(routerAddress);

    address public constant DEGEN = 0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984; // degen: 0x4ed4E862860beD51a9570b96d89aF5E1B0Efefed;
    address public constant WETH = 0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6; // base: weth 0x4200000000000000000000000000000000000006;

    IERC20 public degenToken = IERC20(DEGEN);

    // For this example, we will set the pool fee to 0.3%.
    uint24 public constant poolFee = 3000;

    constructor() {}

    function swapExactInputSingle(
        uint256 amountIn
    ) external returns (uint256 amountOut) {
        degenToken.approve(address(swapRouter), amountIn);

        ISwapRouter.ExactInputSingleParams memory params = ISwapRouter
            .ExactInputSingleParams({
                tokenIn: WETH,
                tokenOut: DEGEN,
                fee: poolFee,
                recipient: address(this),
                deadline: block.timestamp,
                amountIn: amountIn,
                amountOutMinimum: 0,
                sqrtPriceLimitX96: 0
            });

        amountOut = swapRouter.exactInputSingle(params);
    }
}
