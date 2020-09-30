pragma solidity >=0.6.12;
//SPDX-License-Identifier: MIT-0
import './interfaces/ILiquidSwapFactory.sol';
import './LiquidSwapPair.sol';
import "@openzeppelin/contracts/access/Ownable.sol";
import "./libraries/LiquidSwapLibrary.sol";

contract LiquidSwapFactory is ILiquidSwapFactory, Ownable {
    address public override migrator;

    mapping(address => mapping(address => ILiquidSwapPair)) public pairMapping;
    mapping(address => ILiquidSwapFee) public feeContract;

    ILiquidSwapFee defaultFeeContract;

    ILiquidSwapPair[] public allPairs;

    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    constructor(address owner, ILiquidSwapFee _defaultFeeContract) public {
        transferOwnership(owner);
        defaultFeeContract = _defaultFeeContract;
    }

    function allPairsLength() external override view returns (uint) {
        return allPairs.length;
    }

    function getPairByIndex(uint index) external override view returns (ILiquidSwapPair) {
        return allPairs[index];
    }

    function pairCodeHash() external pure returns (bytes32) {
        return keccak256(type(LiquidSwapPair).creationCode);
    }

    function createPair(address tokenA, address tokenB) external override returns (ILiquidSwapPair pair) {
        require(tokenA != tokenB, 'LiquidSwap: IDENTICAL_ADDRESSES');
        (address token0, address token1) = LiquidSwapLibrary.sortTokens(tokenA, tokenB);
        require(token0 != address(0), 'LiquidSwap: ZERO_ADDRESS');
        require(pairMapping[token0][token1] == ILiquidSwapPair(0), 'LiquidSwap: PAIR_EXISTS'); // single check is sufficient
        bytes memory bytecode = type(LiquidSwapPair).creationCode;
        bytes32 salt = keccak256(abi.encodePacked(token0, token1));
        assembly {
            pair := create2(0, add(bytecode, 32), mload(bytecode), salt)
        }
        ILiquidSwapPair(pair).initialize(token0, token1);
        pairMapping[token0][token1] = pair;
        pairMapping[token1][token0] = pair; // populate mapping in the reverse direction
        allPairs.push(ILiquidSwapPair(pair));
        emit PairCreated(token0, token1, pair, allPairs.length);
    }

    function getPair(address tokenA, address tokenB) external override view returns (ILiquidSwapPair pair){
        return pairMapping[tokenA][tokenB];
    }

    function setMigrator(address _migrator) external override onlyOwner {
        migrator = _migrator;
    }

    function getFeeContract(address _pairContract) external override view returns (ILiquidSwapFee _feeContract){
        ILiquidSwapFee fee = feeContract[_pairContract];
        if(address(fee) != address(0x0)){
            return fee; 
        }
        return defaultFeeContract;
    }

    function setFeeContract(address pair, address _feeContract) external override onlyOwner {
        require(_feeContract != address(0x0), "LiquidSwapFactory: FeeContract cannot be 0x0");
        feeContract[pair] = ILiquidSwapFee(_feeContract);
    }

}
