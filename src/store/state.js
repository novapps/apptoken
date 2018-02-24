export default {
  currentRoute: null,
  web3: {
    address: null,
    coinbase: null,
    error: null,
    instance: null,
    isInjected: false,
    networkId: null
  },
  user: {
    name: '',
    email: '',
    phone: '',
    coinbase: '',
    hasCoinbase: false,
    hasWeb3InjectedBrowser: false,
    isConnectedToApprovedNetwork: false,
    isLoggedIn: false,
    miningEarning: 0,
    balance: 0,
    power: 0
  }
}
