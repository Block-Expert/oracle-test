// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";

contract APIConsumer is ChainlinkClient {
	uint256 public volume;

	address private oracle;
	bytes32 private jobId;
	uint256 private fee;

	/**
	 * Network: Kovan
	 * Oracle: 0x2f90A6D021db21e1B2A077c5a37B3C7E75D15b7e
	 * Job ID: 29fa9aa13bf1468788b7cc4a500a45b8
	 * Fee: 0.1 LINK
	 */

	constructor() {
		setPublicChainlinkToken();
		oracle = 0x2f90A6D021db21e1B2A077c5a37B3C7E75D15b7e;
		jobId = "29fa9aa13bf1468788b7cc4a500a45b8";
		fee = 0.1 * 10**18;
	}

	// Create a Chainlink request a retrieve API response, find the target data,
	// then multiply by 1000000000000000000 (to remove decimal places from data).

	function requestVolumeData() public returns (bytes32 requestId) {
		Chainlink.Request memory request = buildChainlinkRequest(
			jobId,
			address(this),
			this.fulfill.selector
		);

		// Set the URL to perform the GET request on
		Chainlink.add(
			request,
			"get",
			"https://min-api.cryptocompare.com/data/pricemultifull?fsyms=ETH&tsyms=USD"
		);

		Chainlink.add(request, "path", "RAW.ETH.USD.VOLUME24HOUR");

		// Multiply the result by 1000000000000000000(to remove decimals)
		int256 timesAmount = 10**18;
		Chainlink.addInt(request, "times", timesAmount);

		// Send the request
		return sendChainlinkRequestTo(oracle, request, fee);
	}

	// Receive the response in the form of uint256
	function fulfill(bytes32 _requestId, uint256 _volume)
		public
		recordChainlinkFulfillment(_requestId)
	{
		volume = _volume;
	}
}
