import { BuidlerConfig, usePlugin } from '@nomiclabs/buidler/config';
import * as dotenv from 'dotenv';

usePlugin('@nomiclabs/buidler-waffle');
usePlugin('@nomiclabs/buidler-etherscan');
usePlugin('buidler-typechain');
usePlugin('solidity-coverage');

dotenv.config();

const secret: string = process.env.MNEMONIC_OR_PRIVATE_KEY as string;

const config: BuidlerConfig = {
  defaultNetwork: 'buidlerevm',
  solc: {
    version: '0.6.6',
    optimizer: {
      enabled: true,
      runs: 999999,
    },
  },
  networks: {
    buidlerevm: {
      gas: 99999999,
      gasPrice: 1,
      blockGasLimit: 999999999,
      allowUnlimitedContractSize: true,
    },
    ropsten: {
      url: `https://rinkeby.infura.io/v3/${process.env.INFURA_API_KEY}`,
      accounts: [secret],
    },
    coverage: {
      url: 'http://127.0.0.1:8555', // Coverage launches its own ganache-cli client
    },
  },
  typechain: {
    outDir: 'typechain',
    target: 'ethers-v4',
  },
};

export default config;
