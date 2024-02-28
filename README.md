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
- Create ./src/Raffle.sol file
  run

```bash
forge build
```
