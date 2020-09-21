pragma solidity >=0.6.12;
//SPDX-License-Identifier: MIT-0

import "@openzeppelin/contracts/access/Ownable.sol";
import "./interfaces/ILiquidSwapConfig.sol";
import "./interfaces/ILiquidSwapFee.sol";

contract LiquidSwapConfig is ILiquidSwapConfig, Ownable {

    ILiquidSwapFee feeContract;

    function getFeeContract(address token0, address token1) external override view returns(ILiquidSwapFee _feeContract){
        return feeContract;
    }

    function setFeeContract(address token0, address token1, ILiquidSwapFee _feeContract) external override onlyOwner {
        require(_feeContract != ILiquidSwapFee(0), "LiquidSwap: Cannot set the fee contract to 0x0.");
        feeContract = _feeContract;
    }
}