pragma solidity >=0.6.12;
//SPDX-License-Identifier: MIT-0

interface ILiquidSwapFee{
    function getFeeTo() external view returns (address _feeTo);
    function getBase() external view returns (uint _base);
    function getPercent() external view returns (uint _base);
    function setBaseAndPercent(uint _base, uint _percent) external;
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    
}