const { expect } = require('chai')
const Game = artifacts.require("Game");

require('chai')
  .use(require('chai-as-promised'))
  .should()

/*
 * uncomment accounts to access the test accounts made available by the
 * Ethereum client
 * See docs: https://www.trufflesuite.com/docs/truffle/testing/writing-tests-in-javascript
 */
contract("Game", function ([deployer, buyer1, buyer2]) {

  let contract;

  before(async () => {
    contract = await Game.deployed();
  })

  describe('.createRound', () => {
    it("should create a round with success", async () => {
      const result = await contract.createRound();
      const event = result.logs[0].args;
      expect(event.roundId.toNumber()).to.eq(1);
      expect(event.finished).to.eq(false);
    });

    it("should be rejected because of an existing round still unfinished", async () => {
      await contract.createRound().should.be.rejected;
      const amountOfRounds = (await contract.roundCount()).toNumber();
      expect(amountOfRounds).to.eq(1);
    });
  });

  describe('.bet', () => {
    it(`should buyer1 with address[${buyer1}] do the bet with success`, async () => {
      const numbers = [20, 30, 40];
      const value = web3.utils.toWei('1', 'ether');
      const result = await contract.bet(numbers[0], numbers[1], numbers[2], { from: buyer1, value });
      const event = result.logs[0].args;
      expect(event.roundId.toNumber()).to.eq(1);
      expect(event.gamer).to.eq(buyer1);
      expect(event.betValue.toString()).to.eq(value);
      event.numbers.forEach((number) => {
        expect(numbers.map(number => `${number}`)).to.includes(number.toString());
      })
    });

    it(`should buyer2 with address[${buyer2}] do the bet with success`, async () => {
      const numbers = [5, 15, 30];
      const value = web3.utils.toWei('1', 'ether');
      const result = await contract.bet(numbers[0], numbers[1], numbers[2], { from: buyer2, value });
      const event = result.logs[0].args;
      expect(event.roundId.toNumber()).to.eq(1);
      expect(event.gamer).to.eq(buyer2);
      expect(event.betValue.toString()).to.eq(value);
      event.numbers.forEach((number) => {
        expect(numbers.map(number => `${number}`)).to.includes(number.toString());
      })
    });

    it(`should not permit to bet because numbers are out of the allowed range`, async () => {
      const numbers = [0, 15, 61];
      const value = 1;
      await contract.bet(numbers[0], numbers[1], numbers[2], { from: buyer2, value }).should.be.rejected;
    });

    it(`should not permit to bet because value different from 1 Ether is not authorized`, async () => {
      const numbers = [1, 30, 60];
      const value = web3.utils.toWei('1', 'wei');
      await contract.bet(numbers[0], numbers[1], numbers[2], { from: buyer2, value }).should.be.rejected;
    });
  });
  describe('.finishRound', () => {
    it("should finish a round with success", async () => {
      const result = await contract.finishRound();
      const event = result.logs[0].args;
      expect(event.finished).to.eq(true);
    });

    it("should be able to create another round after the first one be finished", async () => {
      const result = await contract.createRound();
      const event = result.logs[0].args;
      expect(event.roundId.toNumber()).to.eq(2);
      expect(event.finished).to.eq(false);
    });
  });
});
