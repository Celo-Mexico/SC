contract OracleBridge is Ownable {
    WrappedToken public wrappedToken;
    mapping(bytes32 => bool) public processedDeposits;

    constructor(address _wrappedTokenAddress) {
        wrappedToken = WrappedToken(_wrappedTokenAddress);
    }

    function confirmDeposit(
        bytes32 depositId,
        address user,
        uint256 amount
    ) external onlyOwner {
        require(!processedDeposits[depositId], "Ya procesado");

        wrappedToken.mint(user, amount);
        processedDeposits[depositId] = true;
    }
}