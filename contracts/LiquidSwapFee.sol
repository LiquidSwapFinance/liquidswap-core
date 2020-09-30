//SPDX-License-Identifier: MIT-0
pragma solidity >= 0.6.12;

import "./interfaces/ILiquidSwapFee.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";

contract LiquidSwapFee is ILiquidSwapFee, Ownable{
    using SafeMath for uint;
    address public feeTo;
    uint public base;
    uint public percent;

    constructor(address _owner, uint _base, uint _percent) public {
        require(_base > 0 && _percent > 0, "LiquidSwapFee: Cannot set base or percent to 0.");
        require(_base >= _percent, "LiquidSwapFee: Cannot set a negative fee.");
        transferOwnership(_owner);
        base = _base;
        percent = percent;        
    }
    
    function getFeeTo() public virtual override view returns (address _feeTo){
        return feeTo;
    }

    function setFeeTo(address _feeTo) public virtual override onlyOwner {
        feeTo = _feeTo;
    }
    
    function getBase() public virtual override view returns (uint _base){
        return base;
    }

    function getPercent() public virtual override view returns (uint _percent){
        return percent;
    }

    function setBaseAndPercent(uint _base, uint _percent) public virtual override onlyOwner {
        require(_base > 0 && _percent > 0, "LiquidSwapFee: Cannot set base or percent to 0.");
        require(_base >= _percent, "LiquidSwapFee: Cannot set a negative fee.");
        base = _base;
        percent = _percent;
    }

    // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) public virtual override view returns (uint amountOut) {
        require(amountIn > 0, 'LiquidSwapFee: INSUFFICIENT_INPUT_AMOUNT');
        require(reserveIn > 0 && reserveOut > 0, 'LiquidSwapFee: INSUFFICIENT_LIQUIDITY');
        uint amountInWithFee = amountIn.mul(percent);
        uint numerator = amountInWithFee.mul(reserveOut);
        uint denominator = reserveIn.mul(base).add(amountInWithFee);
        amountOut = numerator / denominator;
    }

    // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) public virtual override view returns (uint amountIn) {
        require(amountOut > 0, 'LiquidSwapFee: INSUFFICIENT_OUTPUT_AMOUNT');
        require(reserveIn > 0 && reserveOut > 0, 'LiquidSwapFee: INSUFFICIENT_LIQUIDITY');
        uint numerator = reserveIn.mul(amountOut).mul(base);
        uint denominator = reserveOut.sub(amountOut).mul(percent);
        amountIn = (numerator / denominator).add(1);
    }
}