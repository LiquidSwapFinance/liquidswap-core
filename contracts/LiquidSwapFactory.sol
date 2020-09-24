pragma solidity >=0.6.12;
//SPDX-License-Identifier: MIT-0
import './interfaces/ILiquidSwapFactory.sol';
import './LiquidSwapPair.sol';
import "@openzeppelin/contracts/access/Ownable.sol";
import "./libraries/LiquidSwapLibrary.sol";
import "./interfaces/ILiquidSwapFee.sol";

contract LiquidSwapFactory is ILiquidSwapFactory, Ownable {
    address public override migrator;
    ILquidSwapFee public override feeContract;

    mapping(address => mapping(address => address)) public override getPair;
    mapping(address => mapping(address => address)) public override feeContract;

    address[] public override allPairs;

    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    constructor(address owner) public {
        transferOwnership(owner);
    }

    function allPairsLength() external override view returns (uint) {
        return allPairs.length;
    }

    function pairCodeHash() external pure returns (bytes32) {
        return keccak256(type(LiquidSwapPair).creationCode);
    }

    function createPair(address tokenA, address tokenB) external override returns (address pair) {
        require(tokenA != tokenB, 'LiquidSwap: IDENTICAL_ADDRESSES');
        (address token0, address token1) = LiquidSwapLibrary.sortPairs(token0, token1);
        require(token0 != address(0), 'LiquidSwap: ZERO_ADDRESS');
        require(getPair[token0][token1] == address(0), 'LiquidSwap: PAIR_EXISTS'); // single check is sufficient
        bytes memory bytecode = type(LiquidSwapPair).creationCode;
        bytes32 salt = keccak256(abi.encodePacked(token0, token1));
        assembly {
            pair := create2(0, add(bytecode, 32), mload(bytecode), salt)
        }
        LiquidSwapPair(pair).initialize(token0, token1);
        getPair[token0][token1] = pair;
        getPair[token1][token0] = pair; // populate mapping in the reverse direction
        allPairs.push(pair);
        emit PairCreated(token0, token1, pair, allPairs.length);
    }

    function setMigrator(address _migrator) external override onlyOwner {
        migrator = _migrator;
    }

    function getFeeContract(address token0, address token1) external override returns (address _feeContract){
        address fee = feeContract[token0][token1];
        if(fee =! 0x0){
            return fee; 
        }
        return feeContract;
    }

    function setFeeContract(address token0, address token1, ILiquidSwapFee _feeContract) external override onlyOwner {
        feeContract[token0][token1] = _feeContract;
        feeContract[token1][token0] = _feeContract; // populate mapping in the reverse direction
    }

}
