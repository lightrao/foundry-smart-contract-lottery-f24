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

1. Write some deploy scripts
2. Write our tests
   1. Work on local chain
   2. Forked test net
   3. Forked Main net

Create `DeployRaffle.s.sol`, `HelperConfig.s.sol`

## Mock Chainlink VRF Coordinator

We are using `VRFCoordinatorV2Mock`

## Tests & Deploy Script Continued

Create `RaffleTest.t.sol`, `RaffleStageingTest.t.sol`
run:

```bash
forge test
```

## Install dependencies

```bash
forge install Cyfrin/foundry-devops --no-commit
forge install smartcontractkit/chainlink-brownie-contracts@0.6.1 --no-commit
forge install transmissions11/solmate --no-commit
```

## Lots of Tests

run:

```bash
forge coverage
```

Write more test, and run:

```bash
forge test --match-test testRaffleRevertsWHenYouDontPayEnough
forge test --match-test testRaffleRecordsPlayerWhenTheyEnter
```

Note: before player enter raffle, he should have some eth.

## Testing Events in Foundry

run:

```bash
forge test --match-test testEmitsEventOnEntrance
```

## vm.roll & vm.warp

run:

```bash
forge test --match-test testDontAllowPlayersToEnterWhileRaffleIsCalculating
```

## Create Subscription Script

We need:

- create VRF subscription
- fund the VRF subscription
- add `Raffle` contract address as consumer into VRF subscription

refactor `DeployRaffle.s.sol` and add subscription effect into it.
create `Interactions.s.sol` to contain subscription function.

note:

- go to `https://vrf.chain.link/`
- create subscription through UI
- use Metamask to sign message
- use Metamask to sign `0x8103B...64625:CREATE SUBSCRIPTION`
  - FUNCTION TYPE: Create Subscription
  - PARAMETERS:[]
  - HEX DATA: 4 BYTES
    - 0xa21a23e4
- run:

```bash
 $ cast sig "createSubscription()"
 0xa21a23e4

```

- go to `https://openchain.xyz/signatures`, and search `0xa21a23e4`, you get `createSubscription()`

## Create Subscription from the UI

- go to `https://vrf.chain.link/`
- click `Create Subscription`
- sign message
- approve subscription creation
- rceive confirmation
- now we can see subscription ID
- get some Link token from faucet
  - erc20, erc677 are smart contract based tokens
  - add Link contract address to Metamask so you can see the balance of it
- add funds to subscription with Link
  - 0x779...4789(Link token contract address):TRANSFER AND CALL

## Fund Subscription Script

- create `LinkToken.sol`
- run: `forge install transmissions11/solmate --no-commit`
- add `remappings = [
    '@chainlink/contracts/=lib/chainlink-brownie-contracts/contracts',
    '@solmate=lib/solmate/src/',
]` to foundry.toml
- add fund subscription function into `Interactions.s.sol`
- run `forge build`
- update "subscriptionId" in HelperConfig.s.sol with the ID of UI at `https://vrf.chain.link/`
- run:
  ```bash
  source .env
  forge script script/Interactions.s.sol:FundSubscription --rpc-url $SEPOLIA_RPC_URL --private-key $SEPOLIA_PRIVATE_KEY --broadcast
  ```
- view front end UI and Metamask, we see the balance of Link token are changed

## Add Consumer Script

- add `contract AddConsumer is Script` into `interactions.s.sol`
- run `forge install ChainAccelOrg/foundry-devops`
- go to `https://vrf.chain.link/`, when add consumer
  - Metamask will popup, we can see `FUNCTION TYPE: addConsumer(Uint64, address)`
- in our code, call `addConsumer(subId, raffle)` of `VRFCoordinatroV2Mock`
- run `forge build`
- improve `DeployRaffle.s.sol`, create subscription if necesarry, fund the subscription, add consumer contract to the subscription
- do unit test, run `forge test --match-test testDontAllowPlayersToEnterWhileRaffleIsCalculating`

## More Tests

- run `forge coverage`
- run `forge test --match-test testCheckUpkeepReturnsFalseIfItHasNoBalance`
- run `forge test --match-test testCheckUpkeepReturnsFalseIfRaffleIsntOpen`
- run `forge coverage --report debug > coverage.txt`
- run `forge test --match-test testCheckUpkeepReturnsFalseIfEnoughTimeHasntPassed`

## PerformUpkeep Tests

- run `forge test --match-test testPerformUpkeepCanOnlyRunIfCheckUpkeepIsTrue`
- run `forge test --match-test testPerformUpkeepRevertsIfCheckUpkeepIsFalse`

## Getting Event Data into Foundry Scripts

- run `forge test --match-test testPerformUpkeepUpdatesRaffleStateAndEmitsRequestId`

## Intro to Fuzz tests

- run `forge test --match-test testFulfillRandomWordsCanOnlyBeCalledAfterPerformUpkeep`

## One Big Test

- run `forge test --match-test testFulfillRandomWordsPicksAWinnerResetsAndSendsMoney`

## Passing the private key to vm.startBroadcast

- run:
  ```bash
  source .env
  forge test --fork-url $SEPOLIA_RPC_URL
  forge test
  ```
- note: add `skipFork` to test function because we expect it just running on local chain. In real chain, there is no mock.

## Integrations Test
