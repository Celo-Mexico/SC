// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title WrappedToken
 * @dev Contrato base para envolver tokens de otras cadenas.
 */
contract WrappedToken is ERC20, Ownable {
    // Dirección del contrato o sistema que puede acuñar y quemar tokens
    address public minter;

    event Minted(address indexed to, uint256 amount);
    event Burned(address indexed from, uint256 amount);

    constructor(string memory name, string memory symbol)
        ERC20(name, symbol)
    {}

    /**
     * @dev Establece una nueva dirección con permiso de mint/burn
     */
    function setMinter(address _minter) external onlyOwner {
        minter = _minter;
    }

    /**
     * @dev Acuña tokens al depositarse en otra cadena
     */
    function mint(address to, uint256 amount) external {
        require(msg.sender == minter, "No tienes permiso");
        _mint(to, amount);
        emit Minted(to, amount);
    }

    /**
     * @dev Quema tokens cuando se retiran a otra cadena
     */
    function burn(uint256 amount) external {
        _burn(msg.sender, amount);
        emit Burned(msg.sender, amount);
    }
}