pragma solidity >=0.6.12;
//SPDX-License-Identifier: MIT-0

interface ILiquidSwapFee{
    function getFeeTo() external view returns (address _feeTo);
    
}