pragma solidity >=0.6.12;
//SPDX-License-Identifier: MIT-0

import "@openzeppelin/contracts/token/ERC777/ERC777.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract LiquidSwapToken is ERC777, Ownable {
    constructor(string memory _name, string memory _symbol, address[] memory _defaultOperators) public
    ERC777(_name, _symbol, _defaultOperators)
    Ownable()
    {}

    /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).
    function mint(address _to, uint256 _amount) public onlyOwner {
        _mint(_to, _amount, "", "");
    }

    function burn(address _from, uint256 _amount) public onlyOwner {
        _burn(_from, _amount, "", "");
    }
}