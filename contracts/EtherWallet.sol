// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title Ether Wallet Smart Contract
 * @dev A simple wallet contract that allows users to deposit, store, and withdraw Ether.
 *      Each user's balance is tracked separately, and the contract follows security best practices.
 */
contract EtherWallet {
    /* ===== STATE VARIABLES ===== */
    mapping(address => uint256) public balances;

    /* ===== EVENTS ===== */
    event Deposited(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);

    /* ===== ERRORS ===== */
    error ZeroAmount();
    error InsufficientBalance();
    error TransferFailed();

    /* ===== MODIFIERS ===== */
    modifier onlyZeroAmount(uint256 amount) {
        if (amount == 0) {
            revert ZeroAmount();
        }
        _;
    }

    modifier sufficientBalance(address user, uint256 amount) {
        if (balances[user] < amount) {
            revert InsufficientBalance();
        }
        _;
    }

    /* ===== DEPOSIT FUNCTION ===== */
    /**
     * @dev Deposit Ether into the wallet.
     *      The function is payable, so it can receive Ether.
     *      It rejects zero deposits.
     */
    function deposit() external payable
        onlyZeroAmount(msg.value)
    {
        // Update the user's balance
        balances[msg.sender] += msg.value;

        // Emit deposit event
        emit Deposited(msg.sender, msg.value);
    }

    /* ===== WITDRWAL FUNCTION ===== */
    /**
     * @dev Withdraw Ether from the wallet.
     * @param amount The amount of Ether to withdraw (in wei).
     *      The function checks that the amount is greater than zero and that the user has sufficient balance.
     *      It updates the balance before transferring to prevent reentrancy.
     */
    function withdraw(uint256 amount) external
        onlyZeroAmount(amount)
        sufficientBalance(msg.sender, amount)
    {
        // Update balance first (Checks-Effects-Interactions pattern)
        balances[msg.sender] -= amount;

        // Transfer Ether
        (bool success, ) = payable(msg.sender).call{value: amount}("");
        if (!success) {
            revert TransferFailed();
        }

        // Emit withdrawal event
        emit Withdrawn(msg.sender, amount);
    }

    /* ===== VIEW FUNCTIONS ===== */
    /**
     * @dev Returns the balance of the caller.
     * @return The balance of the caller in wei.
     */
    function getBalance() external view returns (uint256) {
        return balances[msg.sender];
    }

    /**
     * @dev Returns the total Ether held by the contract.
     * @return the contract in wei.
     */
    function getContractBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
