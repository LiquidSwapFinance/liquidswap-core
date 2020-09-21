pragma solidity >=0.6.12;
//SPDX-License-Identifier: MIT-0
interface ILiquidSwapFee{
    function getSwapFee(uint _amount0, uint _amount1, uint _balance0, uint _balance1) external view returns (uint _mint0, uint _mint1);
}