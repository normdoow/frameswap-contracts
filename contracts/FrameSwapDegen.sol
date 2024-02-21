// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "hardhat/console.sol";
import "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);

    function transfer(
        address recipient,
        uint256 amount
    ) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool);

    function approve(address spender, uint256 amount) external returns (bool);
}

contract FrameSwapDegen is Ownable {
    address public constant routerAddress =
        0xE592427A0AEce92De3Edee1F18E0157C05861564;
    // base router: 0x2626664c2603336E57B271c5C0b26F421741e481;
    ISwapRouter public immutable swapRouter = ISwapRouter(routerAddress);

    //TODO: Could do USDC
    address public constant DEGEN = 0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984; // degen: 0x4ed4E862860beD51a9570b96d89aF5E1B0Efefed;
    address public constant WETH = 0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6; // base: weth 0x4200000000000000000000000000000000000006;

    IERC20 public degenToken = IERC20(DEGEN);
    IERC20 public wethToken = IERC20(WETH);

    uint24 public constant poolFee = 3000;
    uint24 public constant frameSwapFee = 1500;

    constructor(address owner) Ownable(owner) {}

    function swapExactInputSingle(
        uint256 amountIn,
        address recipient
    ) external onlyOwner returns (uint256 amountOut) {
        wethToken.transferFrom(recipient, address(this), amountIn);
        uint256 amountInAfterFee = amountIn - (amountIn * frameSwapFee) / 1e6;
        wethToken.approve(address(swapRouter), amountInAfterFee);

        ISwapRouter.ExactInputSingleParams memory params = ISwapRouter
            .ExactInputSingleParams({
                tokenIn: WETH,
                tokenOut: DEGEN,
                fee: poolFee,
                recipient: recipient, //need to send it to sender not myself
                deadline: block.timestamp,
                amountIn: amountInAfterFee,
                amountOutMinimum: 0,
                sqrtPriceLimitX96: 0
            });

        amountOut = swapRouter.exactInputSingle(params);
    }

    function withdraw() external onlyOwner {
        uint balance = address(this).balance;
        (bool success, ) = msg.sender.call{value: balance}("");
        require(success, "Withdrawal failed");
    }
}
