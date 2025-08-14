pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Troncoin is ERC20{
    
    constructor(uint256 initialSupply) ERC20("Tron","trn"){
         _mint(msg.sender, initialSupply);
    }
}