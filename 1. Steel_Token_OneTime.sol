// SPDX-License-Identifier: MIT
// Author SteelDragon 2025

// A simple secure ERC20 token contract that mints a fixed, non-expandable supply 
// of 300 million tokens to the deployer at creation with no ability to 
// mint additional or burn tokens, ensuring a fixed supply.

pragma solidity ^0.8.20;

// Import OpenZeppelin's ERC20 standard token contract
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable2Step.sol";

/**
 * @title Steel1Token
 * @dev ERC20 token with fixed supply of 300 million tokens
 * All tokens are minted to the deployer at contract creation
 * No additional tokens can be minted or burnt after deployment
 * Uses two-step ownership transfer for enhanced security
 */
contract Steel1Token is ERC20, Ownable2Step {
    // Event for token creation (in addition to standard Transfer event)
    event TokenCreated(address indexed creator, uint256 initialSupply);
    
    // Pre-computed value: 300,000,000 * 10^18
    uint256 private constant INITIAL_SUPPLY = 300_000_000 * 10**18;
    
    // Constructor: Runs once when the contract is deployed
    constructor() ERC20("Steel1Token", "Steel1") Ownable(msg.sender) {
        // Mint 300,000,000 tokens to the contract deployer (msg.sender)
        _update(address(0), msg.sender, INITIAL_SUPPLY);
        
        // Emit custom event
        emit TokenCreated(msg.sender, INITIAL_SUPPLY);
    }
    
    // Override _update to prevent any minting after deployment
    function _update(address from, address to, uint256 value) internal virtual override {
        if (from == address(0) && to != address(0)) {
            // This is a mint operation
            if (totalSupply() > 0) {
                // If tokens already exist, prevent additional minting
                revert("Steel1Token: minting disabled after deployment");
            }
        }
        super._update(from, to, value);
    }
    
    // Additional metadata about the token
    function website() external pure returns (string memory) {
        return "https://yourproject.com";
    }
}