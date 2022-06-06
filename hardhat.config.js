require('@nomiclabs/hardhat-waffle');

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: '0.8.4',
  defaultNetwork: 'mainnet',
  networks: {
    localhost: {
      url: 'http://127.0.0.1:8545',
    },
    hardhat: {},
    testnet: {
      url: 'https://data-seed-prebsc-2-s2.binance.org:8545/',
      chainId: 97,
      gasPrice: 20000000000,
      accounts: [
        '9897c2141889ea20133ebe4047f212f6ca9924f54a44584dc5456bbfd8d9c1cb',
      ],
    },
    mainnet: {
      url: 'https://bsc-dataseed.binance.org/',
      chainId: 56,
      gasPrice: 20000000000,
      accounts: [
        '9897c2141889ea20133ebe4047f212f6ca9924f54a44584dc5456bbfd8d9c1cb',
      ],
    },
  },
  paths: {
    sources: './contracts',
    tests: './test',
    cache: './cache',
    artifacts: './artifacts',
  },
  mocha: {
    timeout: 20000,
  },
};
