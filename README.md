# Ether Wallet Smart Contract

## Project Overview

A simple yet secure Ethereum wallet smart contract that allows users to deposit, store, and withdraw Ether. Each user's balance is tracked individually, ensuring that one user's balance does not affect another's. The contract follows Solidity best practices, including the Checks-Effects-Interactions pattern to prevent reentrancy attacks, and uses events for transparency.

## Features

- **Ether Deposit**: Users can deposit Ether via a payable function. Zero deposits are rejected.
- **Individual Balance Management**: Each user's balance is stored in a mapping, ensuring isolation between accounts.
- **Secure Withdrawal**: Users can withdraw only their own funds, with checks for sufficient balance and non-zero amount. The balance is updated before the transfer to prevent reentrancy.
- **Validation**: All functions use `require` statements with clear error messages for invalid operations.
- **Event Logging**: Emits `Deposited` and `Withdrawn` events for transparency and easy tracking on the blockchain.
- **Balance Inquiry**: Functions to check an individual's balance and the total contract balance.

## Technologies Used

- **Solidity** ^0.8.0 (leveraging built-in overflow protection)
- **Ethereum Virtual Machine (EVM)**
- **Remix IDE** (for development, testing, and deployment)
- **MetaMask** (optional, for testing on live testnets)

## Smart Contract Architecture

### State Variables
- `balances`: A `mapping` that maps an Ethereum address to its balance (in wei).

### Events
- `Deposited(address indexed user, uint256 amount)`: Emitted when a user successfully deposits Ether.
- `Withdrawn(address indexed user, uint256 amount)`: Emitted when a user successfully withdraws Ether.

### Functions
#### External Functions
- `deposit()`: Payable function to add Ether to the caller's balance.
- `withdraw(uint256 amount)`: Allows the caller to withdraw a specified amount of Ether.

#### View Functions
- `getBalance()`: Returns the caller's balance.
- `getContractBalance()`: Returns the total Ether held by the contract.

### Security Considerations
- **Reentrancy Protection**: The contract follows the Checks-Effects-Interactions pattern by updating the user's balance before performing the external call (transfer).
- **Solidity ^0.8.x**: Built-in protection against integer overflows and underflows.
- **Access Control**: While the contract does not restrict who can deposit or withdraw (beyond the balance checks), each user can only affect their own balance.
- **Error Handling**: Custom error messages for clarity (though the current version uses `require` with strings; for production, custom errors are recommended but omitted here for simplicity and compatibility).

## Contract Address
Once deployed, the contract address will be provided by Remix IDE.

## Deployment Instructions

### Using Remix IDE
1. Go to [Remix IDE](https://remix.ethereum.org).
2. Create a new file in the `contracts` directory (e.g., `EtherWallet.sol`).
3. Copy and paste the Solidity code from `contracts/EtherWallet.sol` into this file.
4. Compile the contract:
   - Go to the "Solidity Compiler" tab.
   - Ensure the compiler version is set to `0.8.0` or higher (but compatible with `^0.8.0`).
   - Click "Compile EtherWallet.sol".
5. Deploy the contract:
   - Go to the "Deploy & Run Transactions" tab.
   - Select the `EtherWallet` contract from the dropdown.
   - Choose the environment: "JavaScript VM" (for testing) or "Injected Web3" (for MetaMask/testnet).
   - Click "Deploy".

## Testing Guide (Using Remix IDE's JavaScript VM)

### Test Accounts
Remix's JavaScript VM provides several test accounts with 100 ETH each by default:
- Account 0: `0x5B38Da6a701c568545dCfcB03FcB875f56beddC4`
- Account 1: `0xAb8483F64d9C6d1EcF9b849Ae677dD3315835Cb2`
- Account 2: `0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db`
- ... and more.

### Test Cases

#### Test Case 1: Deposit Ether
1. **Account**: Use Account 0.
2. **Function**: `deposit()`.
3. **Value**: Set to 1 ether (or any amount > 0).
4. **Expected**:
   - Transaction succeeds.
   - The `Deposited` event is logged with the user's address and the deposited amount.
   - Calling `getBalance()` for Account 0 returns the deposited amount.

#### Test Case 2: Deposit from Multiple Accounts
1. **Account**: Account 1.
2. **Function**: `deposit()`.
3. **Value**: 2 ether.
4. **Expected**:
   - Transaction succeeds.
   - `Deposited` event for Account 1.
   - `getBalance()` for Account 1 returns 2 ether.
5. **Repeat** for Account 2 with 3 ether.
6. **Verify**:
   - `getBalance()` for Account 0 is still 1 ether (unchanged).
   - `getContractBalance()` returns 6 ether (1+2+3).

#### Test Case 3: Withdraw Valid Amount
1. **Account**: Account 0 (which has 1 ether from Test Case 1).
2. **Function**: `withdraw(uint256 amount)`.
3. **Amount**: 0.5 ether.
4. **Expected**:
   - Transaction succeeds.
   - `Withdrawn` event logged for Account 0 with 0.5 ether.
   - `getBalance()` for Account 0 now returns 0.5 ether.
   - `getContractBalance()` reduces by 0.5 ether.

#### Test Case 4: Attempt Withdrawal Exceeding Balance
1. **Account**: Account 0 (now has 0.5 ether).
2. **Function**: `withdraw(uint256 amount)`.
3. **Amount**: 1 ether (more than the balance).
4. **Expected**:
   - Transaction reverts with the error: "InsufficientBalance".

#### Test Case 5: Attempt Zero Withdrawal
1. **Account**: Account 0.
2. **Function**: `withdraw(uint256 amount)`.
3. **Amount**: 0.
4. **Expected**:
   - Transaction reverts with the error: "ZeroAmount".

#### Test Case 6: Verify Events
- After each deposit and withdrawal, check the "Transactions" section in Remix IDE to see the emitted events (`Deposited` and `Withdrawn`).

#### Test Case 7: Verify Contract Balance
- After any deposit or withdrawal, call `getContractBalance()` to ensure it reflects the total Ether held by the contract.

## Expected Outcome

A fully functional Solidity smart contract that:
- Accepts Ether deposits from any user.
- Maintains separate balances for each user.
- Allows secure deposits (rejects zero amounts).
- Maintains individual user balances without interference.
- Allows secure withdrawals with proper validation (sufficient balance, non-zero amount).
- Uses the Checks-Effects-Interactions pattern to prevent reentrancy.
- Emits transparent events for deposits and withdrawals.
- Provides view functions to check individual and contract balances.
- Is fully testable in Remix IDE with clear test cases.

## Files in This Repository

- `contracts/EtherWallet.sol`: The main Solidity smart contract.
- `README.md`: This file, providing an overview, features, deployment instructions, and testing guide.
- `LICENSE`: MIT License.
- `.gitignore`: Files and directories to ignore in version control.
- `screenshots/`: Directory for screenshots (see `screenshots/README.md` for details).

## Future Improvements

- Add a function to allow users to withdraw their entire balance with a single call (e.g., `withdrawAll()`).
- Implement a withdrawal fee (optional) to cover contract maintenance.
- Add multi-signature withdrawal for added security.
- Allow the contract owner to withdraw fees (if implemented).
- Add more detailed events (e.g., including timestamps).
- Implement a pause mechanism for emergency situations.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---
**Note**: This contract is intended for educational purposes and has not been audited for production use. Always conduct thorough testing and consider professional audits before deploying contracts that handle real value.
