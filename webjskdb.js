const Web3 = require('web3');
const WebSocket = require('ws');

const web3 = new Web3('YOUR_ETHEREUM_NODE_URL');
const contractAddress = 'YOUR_CONTRACT_ADDRESS';
const contractABI = [...]; // ABI of your BTCUSDPriceAggregator contract

const contract = new web3.eth.Contract(contractABI, contractAddress);

const ws = new WebSocket('ws://localhost:5001');

async function fetchAndSendPrices() {
    try {
        const chainlinkPrice = await contract.methods.getChainlinkPrice().call();
        const pythPrice = await contract.methods.getPythPrice().call();
        const aggregatedPrice = await contract.methods.getAggregatedPrice().call();

        ws.send(JSON.stringify({ source: 'Chainlink', price: web3.utils.fromWei(chainlinkPrice, 'ether') }));
        ws.send(JSON.stringify({ source: 'Pyth', price: web3.utils.fromWei(pythPrice, 'ether') }));
        ws.send(JSON.stringify({ source: 'Aggregated', price: web3.utils.fromWei(aggregatedPrice, 'ether') }));
    } catch (error) {
        console.error('Error fetching prices:', error);
    }
}

// Fetch prices every 5 seconds
setInterval(fetchAndSendPrices, 5000);