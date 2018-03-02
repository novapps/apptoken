import Web3 from 'web3'
import store from '../../store/'
import { ACTION_TYPES, APPROVED_NETWORK_ID } from '../../util/constants.js'
import APPIT from '../../js/APPIT'

const monitorWeb3 = (state) => {
  let web3 = window.web3
  let web3Injected = false

  // Checking if browser is Web3-injected (Mist/MetaMask)
  if (typeof web3 === 'undefined' || !web3) {
    console.log('monitorWeb3: No web3 in browser')
    web3 = state.web3.instance()
  } else {
    // Use Mist/MetaMask's provider
    web3 = new Web3(web3.currentProvider)
    web3Injected = true
  }

  web3.eth.filter('latest', (error, result) => {
    if (!error) {
      // console.log(result)
    }
  })

  web3.eth.filter('pending', (error, result) => {
    if (!error) {
      // console.log(result)
    }
  })

  let networkId = state && state.web3 ? state.web3.networkId : ''
  let coinbase = state && state.web3 ? state.web3.coinbase : ''

  if (coinbase) {
    APPIT.mine(web3).then((tokenBalance) => {
      store.dispatch(ACTION_TYPES.UPDATE_PROPERTIES, {
        properties: ['tokenBalance'],
        values: [ tokenBalance ]
      })
      APPIT.getPower(web3).then((powerBalance) => {
        store.dispatch(ACTION_TYPES.UPDATE_PROPERTIES, {
          properties: ['powerBalance'],
          values: [ powerBalance ]
        })
        if (web3Injected) {
          setInterval(() => {
            web3.version.getNetwork((err, newNetworkId) => {
              newNetworkId = !err && newNetworkId ? newNetworkId.toString() : ''
              if ((!err && newNetworkId && newNetworkId !== '' && newNetworkId !== networkId) || (!newNetworkId && networkId)) {
                store.dispatch(ACTION_TYPES.LOGOUT)
                window.location.reload()
              } else {
                web3.networkId = newNetworkId
                web3.eth.getCoinbase((err, newCoinbase) => {
                  newCoinbase = !err && newCoinbase ? newCoinbase.toString() : ''
                  if ((!err && newCoinbase && newCoinbase !== '' && newCoinbase !== coinbase && newNetworkId === APPROVED_NETWORK_ID) || (!newCoinbase && coinbase)) {
                    store.dispatch(ACTION_TYPES.LOGOUT)
                    window.location.reload()
                  } else if (!err && newCoinbase && newCoinbase !== '') {
                    if (newCoinbase !== coinbase) {
                      coinbase = newCoinbase
                      store.dispatch(ACTION_TYPES.UPDATE_PROPERTIES, {
                        properties: ['coinbase'],
                        values: [ coinbase ]
                      })
                      APPIT.mine(web3).then((tokenBalance) => {
                        store.dispatch(ACTION_TYPES.UPDATE_PROPERTIES, {
                          properties: ['tokenBalance'],
                          values: [ tokenBalance ]
                        })
                        APPIT.getPower(web3).then((powerBalance) => {
                          store.dispatch(ACTION_TYPES.UPDATE_PROPERTIES, {
                            properties: ['powerBalance'],
                            values: [ powerBalance ]
                          })
                        })
                      })
                    }
                    APPIT.getMiningEarning(web3).then((miningEarning) => {
                      store.dispatch(ACTION_TYPES.UPDATE_PROPERTIES, {
                        properties: ['miningEarning'],
                        values: [ miningEarning ]
                      })
                    })
                  }
                })
              }
            })
          }, 2000)
        } else {
          setInterval(() => {
            APPIT.getMiningEarning(web3).then((miningEarning) => {
              store.dispatch(ACTION_TYPES.UPDATE_PROPERTIES, {
                properties: ['miningEarning'],
                values: [ miningEarning ]
              })
            })
          }, 1000)
        }
      })
    })
  }
}

export default monitorWeb3
