//SPDX-License-Identifier: MIT-0
pragma solidity >= 0.6.12;

import "@openzeppelin/contracts/access/Ownable.sol";

contract LiquidSwapFees is Ownable {
    uint public fee;
    uint public feeMultiplier;
    uint public feeExponent;

    constructor(uint _fee, uint _feeMultiplier, uint _feeExponent) public {
        fee = _fee;
        feeMultiplier = _feeMultiplier;
        feeExponent = _feeExponent;
    }

    function getFee() public view returns(uint){
        return fee;
    }

    function getFeeMultiplier() public view returns(uint _feeMultiplier){
        return feeMultiplier;
    }

    function getFeeExponent() public view returns(uint _feeExponent){
        return feeExponent;
    }

    function setFee(uint _fee) public onlyOwner {
        fee = _fee;
    }

    function setFeeMultiplier(uint _feeMultiplier) public onlyOwner {
        require(_feeMultiplier > 0, "LiquidSwap: Fee Multiplier must be > 0");
        feeMultiplier = _feeMultiplier;
    }

    function setFeeExponent(uint _feeExponent) public onlyOwner {
        require(_feeExponent > 0, "LiquidSwap: Fee Exponent must be > 0");
        feeExponent = _feeExponent;
    }

    function renounceOwnership() public override {
        revert("LiquidSwapFees: Cannot renounce ownership, someone (or something) needs to adjust to market values.");
    }
}