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
