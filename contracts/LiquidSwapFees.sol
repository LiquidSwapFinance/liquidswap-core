//SPDX-License-Identifier: MIT-0
pragma solidity >= 0.6.12;

import "./interfaces/ILiquidSwapFee.sol";

contract LiquidSwapFee is ILiquidSwapFee{
    function getSwapFee(uint _amount0, uint _amount1, uint _balance0, uint _balance1) override external view returns (uint _mint0, uint _mint1){
        return (0,0);
    }
}