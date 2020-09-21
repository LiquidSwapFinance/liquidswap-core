pragma solidity >=0.6.12;
//SPDX-License-Identifier: MIT-0
interface IWETH {
    function deposit() external payable;
    function transfer(address to, uint value) external returns (bool);
    function withdraw(uint) external;
}