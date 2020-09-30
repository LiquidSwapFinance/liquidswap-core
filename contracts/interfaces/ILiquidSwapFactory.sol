pragma solidity >=0.6.12;
import "./ILiquidSwapFee.sol";
import "./ILiquidSwapPair.sol";
//SPDX-License-Identifier: MIT-0
interface ILiquidSwapFactory {
    event PairCreated(address indexed token0, address indexed token1, ILiquidSwapPair pair, uint index);
    function migrator() external view returns (address);

    function getPair(address tokenA, address tokenB) external view returns (ILiquidSwapPair pair);
    function getPairByIndex(uint index) external view returns (ILiquidSwapPair pair);
    function allPairsLength() external view returns (uint);

    function createPair(address token0, address token1) external returns (ILiquidSwapPair pair);

    function getFeeContract(address pair) external view returns (ILiquidSwapFee _feeContract);
    function setFeeContract(address pair, address _feeContract) external;
    function setMigrator(address) external;
}
