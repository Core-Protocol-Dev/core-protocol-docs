// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title STC Payment Program
 * @dev Statice Infrastructure Energy Protocol - Settlement Layer
 */
interface IERC20 {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract STCPaymentProcessor {
    address public owner;
    IERC20 public stcToken;

    event PaymentReceived(address indexed payer, uint256 amount, uint256 timestamp);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor(address _stcTokenAddress) {
        owner = msg.sender;
        stcToken = IERC20(_stcTokenAddress);
    }

    function processPayment(uint256 amount) external {
        require(amount > 0, "Amount must be greater than zero");
        
        // STCトークンを支払者からコントラクト（またはオーナー）へ転送
        bool success = stcToken.transferFrom(msg.sender, owner, amount);
        require(success, "Token transfer failed");

        emit PaymentReceived(msg.sender, amount, block.timestamp);
    }

    function updateOwner(address newOwner) external onlyOwner {
        require(newOwner != address(0), "Invalid address");
        owner = newOwner;
    }
}
