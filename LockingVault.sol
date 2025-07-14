// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract LockingVault {
    using SafeERC20 for IERC20;

    address public immutable token; // Token a bloquear (ej: USDC)
    address public bridgeOperator; // Dirección autorizada a liberar tokens

    event TokensLocked(address indexed user, uint256 amount);
    event TokensUnlocked(address indexed user, uint256 amount);

    constructor(address _token) {
        token = _token;
        bridgeOperator = msg.sender;
    }

    modifier onlyBridge() {
        require(msg.sender == bridgeOperator, "No tienes permiso");
        _;
    }

    function lockTokens(address user, uint256 amount) external {
        IERC20(token).safeTransferFrom(user, address(this), amount);
        emit TokensLocked(user, amount);
    }

    function unlockTokens(address user, uint256 amount) external onlyBridge {
        IERC20(token).safeTransfer(user, amount);
        emit TokensUnlocked(user, amount);
    }
}