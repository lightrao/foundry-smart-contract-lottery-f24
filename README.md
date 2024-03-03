# foundry-smart-contract-lottery-f24

A simple project which illustrate how to use smart contract.

## Requirements

- git
- foundry

## setup

```bash
mkdir foundry-smart-contract-lottery-f24
cd foundry-smart-contract-lottery-f24
code .
forge init
```

## Blueprint

Create a proveably random smart contract lottery.

1. User can enter by paying for ticket
   1. The ticket fees are going to go to the winner during the draw
2. After X period of time, the lottery will automatically draw a winner
   1. and the will be done programatically
3. Using Chainlink VRF & Chainlink Automation
   1. Chainlink VRF -> Randomness
   2. Chainlink Automation -> Time based trigger

## Raffle.sol Setup

- Empty script, src, test folders
- Create ./src/Raffle.sol file, then run:

```bash
forge build
```

## Solidity Contract Layout

```solidity
// Layout of Contract:
// version
// imports
// errors
// interfaces, libraries, contracts
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// internal & private view & pure functions
// external & public view & pure functions
```

## Custom Errors

compare to `require`, `error` are more gas efficient

## Events

```solidity
// declare
event EnteredRaffle(address indexed player);
// use
emit EnteredRaffle(msg.sender);
```

## block.timestamp

block.timestamp is a value that represents the time when a block was created on the Ethereum blockchain. It is measured in seconds since the Unix epoch, which is January 1, 1970.
Each round of lottery takes a certain amount of time, we can use block.timestamp to measure the interval between two round of lottery.

## Chainlink VRF

https://docs.chain.link/vrf

## Implementing Chainlink VRF

Edit Raffle.sol file to realize VRF.

We need to install dependency:

```bash
forge install smartcontractkit/chainlink-brownie-contracts@0.6.1 --no-commit
```

We need to config foundry.toml, add line:

```
remappings = ['@chainlink/contracts/=lib/chainlink-brownie-contracts/contracts']
```

try run:

```bash
forge build
```

## Modulo

The modulo operator (often denoted as %) is a mathematical operation that returns the remainder when one number is divided by another.
The range of values for an integer modulo operation of n is 0 to n - 1. For instance, if you calculate a mod 7, the result can be any integer from 0 to 6.

## Enum

An enum type is a special data type that enables for a variable to be a set of predefined constants. The variable must be equal to one of the values that have been predefined for it.

```solidity
enum RaffleState {
   OPEN,        // 0
   CALCULATING, // 1
}
```

In the running process of contract, you should check and change raffle's state.

## Resetting an array

After pick winner, we should reset raffle players:

```solidity
s_players = new address payable[] (0);
```

## Note on building

Writing code is an iterative process.

## CEI (Checks, Effects, Interactions)

Check and revert as early as possible in a function of smart contract to realize gas efficent.
Then effect our own contract.
Finally do external interactions with other contract, we need to avoid reentrancy attacks.

## Introduction to Chainlink Automation

- Go to: https://automation.chain.link/
- Connect MetaMask wallet
- Register new Upkeep, then choose `Time-based` Trigger
- Create contract `Counter`(Which in ./src/sublesson/Counter.sol)
- Deploy `Counter` on sepolia with address `0x17a87f6bEFc7F719231d826EDbca2aF2b1BB5092` and verify it
- Go back to `Register new Upkeep`, fulfill `Target contract address` with `0x17a87f6bEFc7F719231d826EDbca2aF2b1BB5092`
- Fulfill ABI if needed(you can get ABI from Remix)
- Contract call -> Target function -> `count`
- Specify your time schedule with CRON expression `*/5 * * * *`, meaning for very 5 minutes call `count` one time
- Submit, then chainlink keeper will:
  - Deploy CRON job contract
  - DoneReceive CRON job contract deployment confirmation
  - DoneRequest time-based upkeep registration
  - DoneReceive registration confirmation

## Implementing Chainlink Keepers - checkUpkeep

- `checkUpkeep`: this is the funciton that the chainlink automation nodes call to see if it's time to call \`performUpkeep\` (when it return `true`)
- `performUpkeep`: kick off the chainlink vrf call for us

```solidity
forge compile # or forge build
```

## Mid-Lesson Recap

we just already create a framwork for Raffle contract

## Tests & Deploy Script Setup
