// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title DataLayerProvision
 * @dev Statice Infrastructure Energy Protocol - Phase 0 Core Architecture
 * Managed by the Statice Foundation. All rights reserved.
 */

interface IERC20 {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract DataLayerProvision {
    address public owner;
    IERC20 public networkCapacityToken;

    event CapacityAllocated(address indexed contributor, uint256 capacityAmount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor(address _tokenAddress) {
        owner = msg.sender;
        networkCapacityToken = IERC20(_tokenAddress);
    }

    function allocateCapacity(uint256 _amount) external returns (bool) {
        require(_amount > 0, "Invalid capacity amount");
        bool success = networkCapacityToken.transferFrom(msg.sender, owner, _amount);
        if (success) {
            emit CapacityAllocated(msg.sender, _amount);
        }
        return success;
    }

    function withdrawToken(address _token, uint256 _amount) external onlyOwner {
        IERC20(_token).transferFrom(address(this), owner, _amount);
    }
}
