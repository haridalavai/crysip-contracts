pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { SafeERC20 } from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import { ERC20 } from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./IPancakeswap.sol"; 

contract Swap{
    using SafeERC20 for ERC20;

    address private PS_ROUTER = 0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3;
    address private USDT = 0x7ef95a0FEE0Dd31b22626fA2e10Ee6A223F8a684;
    IPancakeSwap public pancakeSwap;

    constructor(){
        pancakeSwap = IPancakeSwap(PS_ROUTER);
    }

    function swap(uint _amt, address _tokenIn, address _tokenOut,address _to) public returns(uint[] memory result) {

        address[] memory path = new address[](2);
        path[0] = _tokenIn;
        path[1] = _tokenOut;

        ERC20(_tokenIn).safeApprove(address(pancakeSwap), _amt);
        result = pancakeSwap.swapExactTokensForTokens(_amt, 0, path, address(this), block.timestamp);
        ERC20(_tokenOut).safeTransfer(_to, result[1]);

    }

    function swapOneForMany(uint _amt,address _tokenIn, address[] memory _currencyArray, uint[] memory _distributionArray) public{
        require(_currencyArray.length == _distributionArray.length, "Invalid distribution data");
        
        IERC20(_tokenIn).transferFrom(msg.sender, address(this), _amt);
        for(uint i =0; i < _currencyArray.length; i++ ){
            uint _da = (_amt/10000)*_distributionArray[i];
            swap(_da, _tokenIn, _currencyArray[i],msg.sender);
        }

    }

    function swapManyForOne(address[] memory _currencyArray, uint[] memory _amtDistribution, address _tokenOut) public{
        require(_currencyArray.length == _amtDistribution.length, "Invalid distribution data");

        for(uint i = 0; i< _currencyArray.length; i++){
            IERC20(_currencyArray[i]).transferFrom(msg.sender,address(this),_amtDistribution[i]);
            swap(_amtDistribution[i],_currencyArray[i],_tokenOut,msg.sender);
        }

    }

    function swapManyForMany(address[] memory _currencyInArray, uint[] memory _distributionArray, address[] memory _currencyOutArray, uint[] memory _amtDistribution) public{
        require(_currencyInArray.length == _distributionArray.length, "Invalid distribution data");
        require(_currencyOutArray.length == _amtDistribution.length, "Invalid distribution data");

        uint _usdtAmt;

        for(uint i = 0; i < _currencyInArray.length; i++){
            IERC20(_currencyInArray[i]).transferFrom(msg.sender,address(this),_amtDistribution[i]);
            uint[] memory _res = swap(_amtDistribution[i],_currencyInArray[i],USDT,address(this));
            _usdtAmt = _usdtAmt + _res[1];
        }

        for(uint i = 0; i< _currencyOutArray.length; i++){
             uint _da = (_usdtAmt/10000)*_distributionArray[i];
            swap(_da, USDT, _currencyOutArray[i],msg.sender);
        }

    }


   }