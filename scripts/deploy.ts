import { ethers } from '@nomiclabs/buidler';

async function main() {
  const proxyAddress = '0x600e7E2B520D51a7FE5e404E73Fb0D98bF2A913E';
  const ffyicard = await ethers.getContract('FfyiCard');
  // If we had constructor arguments, they would be passed into deploy()
  const ffyicardContract = await ffyicard.deploy(proxyAddress);

  const ffyicardFactory = await ethers.getContract('FfyiCardFactory');

  const ffyicardFactoryContract = await ffyicardFactory.deploy(proxyAddress, ffyicardContract.address);
  // The address the Contract WILL have once mined
  console.log(ffyicardContract.address);
  // The transaction that was sent to the network to deploy the Contract
  console.log(ffyicardContract.deployTransaction.hash);

  console.log(ffyicardFactoryContract.address);
  // The contract is NOT deployed yet; we must wait until it is mined
  await ffyicardContract.deployed();
  await ffyicardFactoryContract.deployed();
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
