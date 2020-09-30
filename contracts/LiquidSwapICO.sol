//SPDX-License-Identifier: MIT-0
pragma solidity >= 0.6.12;

import "@openzeppelin/contracts/token/ERC777/ERC777.sol";

contract LiquidSwapICO is ERC777{
    
    uint public immutable launchBlock;
    address public immutable backingToken;
    uint public immutable depositMin = 1^16 wei;
    ILiquidSwapPair public liquidityPool = 0x0;

    event Deposit(address owner, uint amount);
    event Withdraw(address owner, uint amount);
    
    modifier beforeIco(){
        require(launchBlock < now, "LiquidSwapICO: The ICO has ended.");
    }

    modifier afterIco(){
        require(launchBlock >= now, "LiquidSwapICO: The ICO has not yet ended.");
    }

    modifier beforeClose(){
        require(liquidityPool == address(0x0), "LiquidSwapICO: The ICO has completed.");
    }

    modifier afterClose(){
        require(liquidityPool != address(0x0), "LiquidSwapICO: The ICO has not yet complete. Call closeICO() to end it.");
    }

    modifier onlyETH(){
        return backingToken == address(0x0);
    }
    modifier onlyERC20(){
        return backingToken != address(0x0);
    }

    constructor(address _backingToken, uint _launchBlock, uint _depositMin){
        backingToken = _backingToken;
        launchBlock = _launchBlock;
        depositMin = _depositMin;
    }

    function deposit() public payable onlyETH beforeICO {
        require(msg.value >= icoDepositMin, "LiquidSwapICO: You must deposit at least " + icoDepositMin + " to participate in the ICO.");
        _mint(msg.sender, msg.value, "", "");
    }

    function withdraw(uint amount) public onlyETH beforeICO {
        require(amount >= icoDepositMin, "LiquidSwapICO: You must withdraw at least " + icoDepositMin + " to withdraw.");
        require(balanceOf(tokenHolder) >= amount);
        _burn(msg.sender, amount, "", "");
        msg.sender.send(amount);        
    }

    function depositERC20(uint amount) public payable onlyERC20 beforeICO {
        IERC20 back = IERC20(backingToken);
        require(back.balanceOf(backingToken) >= depositMin, "LiquidSwapICO: You must deposit at least " + icoDepositMin + " to deposit.");
        require(back.allowance(msg.sender, address(this)) >= amount, "LiquidSwapICO: You must first call approve on the ERC20 to approve that amount for this contract to spend it.");
        require(back.transferFrom(msg.sender, address(this), amount), "LiquidSwapICO: The ERC20 transfer did not succeed.");
        _mint(msg.sender, amount, "", "");
    }

    function withdrawERC20(uint amount) public payable onlyERC20 beforeICO {
        IERC20 back = IERC20(backingToken);
        require(amount >= icoDepositMin, "LiquidSwapICO: You must withdraw at least " + icoDepositMin + " to withdraw.");
        require(balanceOf(msg.sender) >= amount, "LiquidSwapICO: You don't have that much to deposit.");
        require(back.transfer(msg.sender, amount), "LiquidSwapICO: The ERC20 transfer did not succeed.");
        _burn(msg.sender, amount);
    }

    function closeICO() public afterICO beforeClose {
        //TODO: Launch the factory, then the pair, then the new token.
        //TODO: Set the liquidityPool.
        //TODO: Burn half the supply.
        //TODO: Mint all the tokens.
        //TODO: Transfer everything to the liquidityPool.
        ended = true;
    }

    function redeem(uint amount) afterICO afterClose {
        IERC20 lpToken = ILiquidSwapPair(liquidityPool);
        require(amount >= icoDepositMin, "LiquidSwapICO: You must redeem at least " + icoDepositMin + " to redeem.");
        require(balanceOf(tokenHolder) >= amount);
        //TODO: Compute the amount to actually send based on the ratio of ownership over the amount of LP tokens held.
        require(lpToken.transfer(msg.sender, amount), "LiquidSwapICO: The ERC20 transfer failed.");
        _burn(msg.sender, amount);
    }

}