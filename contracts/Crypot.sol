pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { SafeERC20 } from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import { ERC20 } from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./IPancakeswap.sol"; 

contract Crypot {

    using SafeERC20 for ERC20;

    string public name;
    string public description;
    address[] public currencies;
    uint[] public units;
    mapping(address=>uint) public distribution;
    address public m_owner;
    uint public investerCount;
    address[] public investors;
    mapping(address=>uint) public accountAmtMap;
    mapping(address=>bool) public hasInvested;
    address private USDT = 0x7ef95a0FEE0Dd31b22626fA2e10Ee6A223F8a684;
    address private PS_ROUTER = 0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3;

    IPancakeSwap public pancakeSwap;

    modifier restricted() {
        require(msg.sender == m_owner);
        _;
    }

    constructor(string memory _name, string memory _desc, address[] memory _currencies, uint[] memory _units, address _owner){
        require(_currencies.length == _units.length,'invalid distribution data');

        name = _name;
        description = _desc;
        currencies = _currencies;
        units = _units;
        m_owner = _owner;

        for(uint i = 0; i< currencies.length; i++)
        {
            distribution[_currencies[i]] = _units[i];
        }

        pancakeSwap = IPancakeSwap(PS_ROUTER);

    }

    function getCrypotData() public view returns( string memory _name, string memory _description, address[] memory _currencies,uint[] memory _units, address _createdBy, uint _totalInvestors) {
        return (name,description,currencies,units,m_owner,investerCount);
    }

    function getDistribution(address _token) public view returns(uint) {
        return(distribution[_token]);
    }

    function setName(string memory _newName) public restricted {
        name = _newName;
    }

    function setDescription(string memory _newDescription) public restricted {
        description = _newDescription;
    }

    function changeDistribution(address[] memory _currencies,uint[] memory _units) public restricted {

        require(_currencies.length == _units.length,'invalid distribution data');

         for(uint i = 0; i< currencies.length; i++)
        {
            distribution[currencies[i]] = 0;
        }

        currencies = _currencies;
        units = _units;

        for(uint i = 0; i< currencies.length; i++)
        {
            distribution[_currencies[i]] = _units[i];
        }


    }

    function isOwner() public view returns(bool){
        if(msg.sender == m_owner)
        {
            return true;
        }else{
            return false;
        }
    }

    function swap(uint _amt, address _tokenIn, address _tokenOut,address _to) public returns(uint[] memory result) {

        address[] memory path = new address[](2);
        path[0] = _tokenIn;
        path[1] = _tokenOut;

        ERC20(_tokenIn).safeApprove(address(pancakeSwap), _amt);
        result = pancakeSwap.swapExactTokensForTokens(_amt, 0, path, address(this), block.timestamp);
        ERC20(_tokenOut).safeTransfer(_to, result[1]);

    }

    function invest(uint _amt) public returns(string memory){

        IERC20(USDT).transferFrom(msg.sender, address(this), _amt);

        for(uint i =0; i < currencies.length; i++ ){
            uint _da = (_amt/10000)*distribution[currencies[i]];
            swap(_da, USDT, currencies[i],msg.sender);
        }
       
        accountAmtMap[msg.sender] += _amt;
        if(!hasInvested[msg.sender]){
            investors.push(msg.sender);
            hasInvested[msg.sender] = true;
            investerCount++;
        }   

        return 'hi';
    }
    


}