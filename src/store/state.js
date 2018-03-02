export default {
  currentRoute: null,
  web3: {
    coinbase: null,
    accounts: [],
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
    tokenBalance: 0,
    powerBalance: 0
  }
}
