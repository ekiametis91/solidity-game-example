# Summary

This project consists in to create a game using Solidity to develop smart contracts to prove the utility of public blockchains in order to achieve integration with web3 and prove some knowledge in thies field.

**Note: The idea behind the project is at least prove and apply different knowledge using Solidity key concepts. The idea of this project is not completed, it's just a demo to show and prove some knowledge behind the use of Solidity and its power.**

# Transactions

The project consist in 3 transactions (`test/Game.test.js` has existing the scenarios described and tested):

- `createRound` => Create a round: The owner of the contract can execute and create a round for the game.
- `bet` => Players can bet: Any account can bet 1 ether.
- `finishRound` => Close the round: The owner can closes the round and the sum of all bets will reward the winner(s) trough a trust division.

**Note: The logic was not finished but I intend to continue to makes possible more concise logic be developed, like chose an address to store all values of the bets, accumulate the bounty if no one wins the round and start a new round with the value of the last reward, and improvements like that.**

# Requirements

There are different ways and possibilities to build, deploy and run your smart contracts. To simplify this process we'll be using Ganache and truffle to makes easy the integration and tests with the blockchain smart contract.

- [Ganache](https://trufflesuite.com/docs/ganache/quickstart/)
- NodeJS and NPM
- `npm i -g truffle`

# Project structure

- `build` - Folder which contains the artifacts built.
- `migrations` - Migrations folder
- `src` - Development artifacts
- `test` - Test folder

# Useful commands

## Compile

Use the command below to compile your smart contracts placed on `/src/contracts`:
- Use the command `yarn compile`

**Note**: When the command runs the built artifacts will be moved to `/build`.

## Deploy

Once you start and Ganache is live in your local machine you can just execute the command below to execute the migrations placed on `/migrations`, ensure the compilation and make the deployment on Ganache:
- Use the command `yarn deploy`

## Test

Once you start and Ganache is live in your local machine you can just execute the test command to see the suite of tests be executed through the local blockchain instance:
- Use the command: `yarn test`

## Console

- Use the command `truffle console` to execute anything you want using the truffle console.