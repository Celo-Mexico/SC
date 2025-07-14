contract MultiSigBridge is Ownable {
    WrappedToken public wrappedToken;

    struct Deposit {
        address user;
        uint256 amount;
        uint approvedCount;
        mapping(address => bool) hasApproved;
    }

    Deposit[] public deposits;
    address[] public validators;

    constructor(address _wrappedToken, address[] memory _validators) {
        wrappedToken = WrappedToken(_wrappedToken);
        validators = _validators;
    }

    function addValidator(address validator) external onlyOwner {
        validators.push(validator);
    }

    function submitSignature(uint256 depositId, bytes32 hash, uint8 v, bytes32 r, bytes32 s) external {
        require(isValidator(msg.sender), "No eres validador");

        // Validar firma
        address signer = ecrecover(hash, v, r, s);
        require(signer == msg.sender, "Firma inválida");

        Deposit storage deposit = deposits[depositId];
        if (!deposit.hasApproved[msg.sender]) {
            deposit.hasApproved[msg.sender] = true;
            deposit.approvedCount++;
        }

        if (deposit.approvedCount >= validators.length / 2 + 1) {
            wrappedToken.mint(deposit.user, deposit.amount);
        }
    }

    function createDeposit(address user, uint256 amount) external {
        deposits.push(Deposit({
            user: user,
            amount: amount,
            approvedCount: 0
        }));
    }

    function isValidator(address addr) internal view returns (bool) {
        for (uint i = 0; i < validators.length; i++) {
            if (validators[i] == addr) return true;
        }
        return false;
    }
}