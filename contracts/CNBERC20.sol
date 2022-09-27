// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

interface ICBBERC721 {
    function createToken(address burner, uint256 amountBurned)
        external
        returns (uint256);
}

contract CNBERC20 is ERC20Burnable, Ownable {
    address private fm2Address;
    address private cbbAddress;
    uint256 private currentClaim;
    uint256 private claimableSupply;
    mapping(address => mapping(uint => bool)) private claimsHistory;

    constructor(address _fm2Address) ERC20("Carbon Bond", "CNB") {
        fm2Address = _fm2Address;
    }

    function createNewSupply(uint newSupply) external onlyOwner {
        newSupply = newSupply * (10**decimals());
        _mint(address(this), newSupply);
        currentClaim = block.timestamp;
        claimableSupply = newSupply;
    }

    function claim() external {
        uint fm2Balance = IERC20(fm2Address).balanceOf(msg.sender);
        require(fm2Balance > 0);
        require(
            claimsHistory[msg.sender][currentClaim] == false,
            "Already claimed"
        );

        uint claimPercentage = (fm2Balance * 100) /
            IERC20(fm2Address).totalSupply();

        _transfer(
            address(this),
            msg.sender,
            (claimPercentage * claimableSupply) / 100
        );

        claimsHistory[msg.sender][currentClaim] = true;
    }

    function burn(uint256 amount) public override {
        super.burn(amount);
        ICBBERC721(cbbAddress).createToken(msg.sender, amount);
    }

    function burnFrom(address account, uint256 amount) public override {
        super.burnFrom(account, amount);
        ICBBERC721(cbbAddress).createToken(account, amount);
    }
}
