module.exports = {
  networks: {
    development: {
      host: "192.168.0.18",
      port: 8545, // This is the Ganache default port. You can change it to the conventional 8545 if your network runs on 8545
      network_id: "5777", // Match any network id. You may need to replace * with your network Id
      from: "", // Add your unlocked account within the double quotes
      gas: 4444444
    },
    ropsten: {
      network_id: 3,
      host: '192.168.0.18',
      port: 8545,
      from: '0x883Dd06cA280b1CD3779397cCA1BE5687cDE1b1b'
    }
  }
};
