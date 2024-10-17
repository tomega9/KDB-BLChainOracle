// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@pythnetwork/pyth-sdk-solidity/IPyth.sol";
import "@pythnetwork/pyth-sdk-solidity/PythStructs.sol";

contract BTCUSDPriceAggregator {
    AggregatorV3Interface internal chainlinkFeed;
    IPyth internal pythContract;
    bytes32 internal constant PYTH_BTC_USD_PRICE_ID = 0xe62df6c8b4a85fe1a67db44dc12de5db330f7ac66b72dc658afedf0f4a415b43;

    constructor(address _chainlinkFeed, address _pythContract) {
        chainlinkFeed = AggregatorV3Interface(_chainlinkFeed);
        pythContract = IPyth(_pythContract);
    }

    function getChainlinkPrice() public view returns (int256) {
        (, int256 price,,,) = chainlinkFeed.latestRoundData();
        return price;
    }

    function getPythPrice() public view returns (int256) {
        PythStructs.Price memory price = pythContract.getPrice(PYTH_BTC_USD_PRICE_ID);
        return int256(price.price);
    }

    function getAggregatedPrice() public view returns (int256) {
        int256 chainlinkPrice = getChainlinkPrice();
        int256 pythPrice = getPythPrice();
        return (chainlinkPrice + pythPrice) / 2;
    }
}