// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract FM2ERC20 is ERC20, Ownable {
    constructor() ERC20("Forest Land", "FM2") {}

    function createNewSupply(address newOwner, uint newSupply)
        external
        onlyOwner
    {
        _mint(newOwner, newSupply * (10**decimals()));
    }
}
