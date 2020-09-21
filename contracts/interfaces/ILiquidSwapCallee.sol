pragma solidity >=0.6.12;
//SPDX-License-Identifier: MIT-0
interface ILiquidSwapCallee {
    function tokenSwapCall(address sender, uint amount0, uint amount1, bytes calldata data) external;
}
