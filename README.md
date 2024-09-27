You will find on this repo the following files :

- `src/Lottery.sol` : The contract we will hack.
- `src/Attacker.sol` : A contract written to attack the Lottery contract.

- `test/Attacker.t.sol` : A test file to test Attacker contract.

- `script/Deploy.s.sol` : A script to deploy both contracts.
- `script/Attacker.s.sol` : A script to run attack from Attacker on Lottery contract.

## Configure the workspace

Please copy the `env.example` file, and rename it `.env`.
Then provide the `PRIVATE_KEY` of an account that holds more than 0.5 ETH on Sepolia.

## Run the test files

Run the following command : `forge test`.

## Run the attack

Deploy command : `forge script script/Deploy.s.sol --rpc-url https://rpc.sepolia.org --broadcast`.

Attack command : `forge script script/Attack.s.sol --rpc-url https://rpc.sepolia.org --broadcast`.

Withdraw command : `forge script script/Withdraw.s.sol --rpc-url https://rpc.sepolia.org --broadcast`.
