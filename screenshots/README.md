# Screenshots Directory

This directory is intended to contain screenshots demonstrating the functionality of the Ether Wallet Smart Contract when tested in Remix IDE.

Expected screenshots (if you choose to capture them):

1. **deploy.png** - Shows the contract deployment in Remix IDE.
2. **deposit.png** - Shows the deposit function being called with a value.
3. **withdraw.png** - Shows the withdraw function being called.
4. **balance_check.png** - Shows the getBalance and getContractBalance functions being called.
5. **remix_tests.png** - Shows the overall Remix IDE interface with the contract deployed and tested.

## How to Generate These Screenshots

1. Deploy the contract in Remix IDE using the JavaScript VM environment.
2. Call the deposit function with a test value (e.g., 1 ether) from an account.
3. Call the withdraw function with a valid amount.
4. Check the balance using getBalance and getContractBalance.
5. Attempt invalid operations (like withdrawing more than the balance) to see the revert messages.
6. Take screenshots of each step to demonstrate the functionality.

## Alternative: Test Networks

For a more realistic demonstration, you can deploy to a public testnet (e.g., Goerli, Sepolia) using MetaMask:
- Get test ETH from a faucet for the testnet.
- Deploy and interact with the contract using real transactions (though on a testnet).