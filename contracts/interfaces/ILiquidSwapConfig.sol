pragma solidity >=0.6.12;
//SPDX-License-Identifier: MIT-0

import "./ILiquidSwapFee.sol";

interface ILiquidSwapConfig {
    function getFeeContract(address _token0, address _token1) external view returns (ILiquidSwapFee feeContract);
    function setFeeContract(address _token0, address _token1, ILiquidSwapFee _feeContract) external;
}