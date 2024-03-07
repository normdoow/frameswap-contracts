// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";

// Swap onFrame on Farcaster
// Checkout frameswap.fi by @nbragg

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
    using Math for *;

    address public constant routerAddress =
        0x2626664c2603336E57B271c5C0b26F421741e481;
    ISwapRouter public immutable swapRouter = ISwapRouter(routerAddress);

    address public constant USDC = 0x833589fCD6eDb6E08f4c7C32D4f71b54bdA02913;
    address public constant WETH9 = 0x4200000000000000000000000000000000000006;
    address public constant DEGEN = 0x4ed4E862860beD51a9570b96d89aF5E1B0Efefed;

    IERC20 public degenToken = IERC20(DEGEN);
    IERC20 public usdcToken = IERC20(USDC);

    uint24 public constant usdcPoolFee = 500;
    uint24 public constant degenPoolFee = 3000;
    uint24 public constant frameSwapFee = 1500;
    uint24 public constant gasFee = 2_000_000; //$2
    uint constant bips = 1_000_000;

    constructor(address owner) Ownable(owner) {}

    function swapExactInputSingle(
        uint256 amountIn,
        address recipient,
        uint256 amountOutMinimum
    ) external onlyOwner returns (uint256 amountOut) {
        usdcToken.transferFrom(recipient, address(this), amountIn);
        uint256 amountInAfterFee = amountIn - getFee(amountIn) - gasFee;
        usdcToken.approve(address(swapRouter), amountInAfterFee);

        ISwapRouter.ExactInputParams memory params = ISwapRouter
            .ExactInputParams({
                path: abi.encodePacked(
                    USDC,
                    usdcPoolFee,
                    WETH9,
                    degenPoolFee,
                    DEGEN
                ),
                recipient: recipient,
                deadline: block.timestamp,
                amountIn: amountInAfterFee,
                amountOutMinimum: amountOutMinimum
            });

        amountOut = swapRouter.exactInput(params);
    }

    function getFee(uint256 amountIn) internal pure returns (uint256) {
        return Math.mulDiv(amountIn, frameSwapFee, bips);
    }

    function withdraw() external onlyOwner {
        uint256 balance = usdcToken.balanceOf(address(this));
        usdcToken.transfer(owner(), balance);
    }
}
