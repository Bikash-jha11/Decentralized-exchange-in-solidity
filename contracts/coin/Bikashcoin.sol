pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Bikashcoin is ERC20{
    
    constructor(uint256 initialSupply) ERC20("Bikash","bik"){
         _mint(msg.sender, initialSupply * 100);
    }
}

