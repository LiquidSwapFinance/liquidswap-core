//SPDX-License-Identifier: MIT-0
pragma solidity >= 0.6.12;

import "./interfaces/ILiquidSwapFee.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract LiquidSwapFee is ILiquidSwapFee, Ownable{
    address public feeTo;

    constructor(address owner) public {
        transferOwnership(owner);
    }
    
    function getFeeTo() override virtual view public returns (address _feeTo){
        return feeTo;
    }

    function setFeeTo(address _feeTo) override virtual public onlyOwner {
        feeTo = _feeTo;
    }
}