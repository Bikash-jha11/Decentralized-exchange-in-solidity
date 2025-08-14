pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Obamacoin is ERC20{
    
    constructor(uint256 initialSupply) ERC20("Obama","obm"){
         _mint(msg.sender, initialSupply);
    }
}