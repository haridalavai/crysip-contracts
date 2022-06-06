pragma solidity ^0.8.4;

import './Crypot.sol';

contract CrypotManager {

    Crypot[] public crypots;
    address public manager;

    constructor() public {
        manager = msg.sender;
    }

    function createCrypot(string memory _name, string memory _desc, address[] memory _currencies, uint[] memory _units) public {

        Crypot newCrypot = new Crypot(_name, _desc, _currencies, _units, msg.sender);
        crypots.push(newCrypot);

    }

    function getCrypots() public view returns(Crypot[] memory _crypots) {
        return crypots;
    }
}