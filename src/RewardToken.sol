// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract RewardToken is ERC20 {
   
    constructor(uint256 initialMint) ERC20("RewardToken", "RT") {
        _mint(msg.sender, initialMint);
    }
}
