const LiquidToken = artifacts.require("LiquidToken");
require('@openzeppelin/test-helpers/configure')({ provider: web3.currentProvider, environment: 'truffle' });
const { singletons } = require('@openzeppelin/test-helpers');

module.exports = async function(deployer) {
    let accounts = await web3.eth.getAccounts();
    await singletons.ERC1820Registry(accounts[0]);
    //const erc1820 = await singletons.ERC1820Registry(accounts[0]);
    await deployer.deploy(LiquidToken);
};
