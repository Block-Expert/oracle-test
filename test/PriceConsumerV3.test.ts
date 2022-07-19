import { expect } from "chai";
import { ethers } from "hardhat";

describe("PriceConsumerV3 test", function () {
  it("test_getLastPrice", async function () {
    // const PriceConsumerV3 = await ethers.getContractFactory("PriceConsumerV3");
    // const consumer = await PriceConsumerV3.deploy();
    // await consumer.deployed();

    const provider = new ethers.providers.JsonRpcProvider("https://rinkeby.infura.io/v3/ef9302f291724713abc77e85a679d058")
    const aggregatorV3InterfaceABI = [
      {
        "inputs": [],
        "stateMutability": "nonpayable",
        "type": "constructor"
      },
      {
        "inputs": [],
        "name": "getLatestPrice",
        "outputs": [
          {
            "internalType": "int256",
            "name": "",
            "type": "int256"
          }
        ],
        "stateMutability": "view",
        "type": "function"
      }
    ]
    const addr = "0xab767997076F2eA5969276cce31c379937C30B0e"
    const priceFeed = new ethers.Contract(addr, aggregatorV3InterfaceABI, provider)
    console.log("address", priceFeed.address)
    const roundData = await priceFeed.getLatestPrice()
    console.log("Latest Round Data", roundData)
  });
});
