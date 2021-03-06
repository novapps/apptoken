import contract from 'truffle-contract'
import AuthContract from '../../build/contracts/Authentication.json'
import { APPROVED_NETWORK_ID, NETWORKS } from '../util/constants'

let auth = null
class Auth {
  constructor () {
    auth = auth || this
    return auth
  }

  editProfile (state = null, data = {}) {
    return new Promise((resolve, reject) => {
      this.accessAuthenticationContractWith({state,
        method: (contractInstance, coinbase) => {
          return new Promise((resolve, reject) => {
            contractInstance.update(
              state.web3.instance().fromUtf8(data.name),
              state.web3.instance().fromUtf8(data.email),
              state.web3.instance().fromUtf8(data.phone),
              { from: coinbase, gas: 4444444 }).then((result) => {
              // Successful Sign-up
                resolve(data)
              }).catch((e) => {
                reject(e)
              })
          })
        }
      }).then((result) => {
        resolve(result)
      })
    })
  }

  signup (state = null, data = {}) {
    return new Promise((resolve, reject) => {
      this.accessAuthenticationContractWith({state,
        method: (contractInstance, coinbase) => {
          return new Promise((resolve, reject) => {
            contractInstance.signup(
              state.web3.instance().fromUtf8(data.name),
              state.web3.instance().fromUtf8(data.email),
              state.web3.instance().fromUtf8(data.phone),
              { from: coinbase, gas: 4444444 }).then((result) => {
              // Successful Sign-up
                resolve(data)
              }).catch((e) => {
                reject(e)
              })
          })
        }
      }).then((result) => {
        resolve(result)
      }).catch((err) => {
        reject(err)
      })
    })
  }

  login (state = null) {
    return new Promise((resolve, reject) => {
      this.accessAuthenticationContractWith({state,
        method: (contractInstance, coinbase) => {
          return new Promise((resolve, reject) => {
            contractInstance.login({from: coinbase}).then((result) => {
              // Successful Fetch
              resolve(this.getUTF8DataOfResults(state, result))
            }).catch((e) => {
              reject(e)
            })
          })
        }
      }).then((result) => {
        resolve(result)
      }).catch((err) => {
        reject(err)
      })
    })
  }

  accessAuthenticationContractWith (dataObject = {}) {
    const state = dataObject.state
    return new Promise((resolve, reject) => {
      if (!state || !state.web3 || !(state.web3.instance)) {
        reject('Web3 is not initialised. Use a Web3 injector')
      } else if (state.web3.networkId) {
        let authContract = contract(AuthContract)
        authContract.setProvider(state.web3.instance().currentProvider)
        state.web3.instance().eth.getCoinbase((err, coinbase) => {
          if (err) {
            console.error(':::Unable to get coinbase for this operation')
            reject(err)
          } else {
            authContract.deployed().then((contractInstance) => {
              dataObject.method(contractInstance, coinbase).then((result) => {
                resolve(result)
              }).catch((err) => {
                reject(err)
              })
            }).catch((err) => {
              reject(err)
            })
          }
        })
      } else {
        var network = NETWORKS[APPROVED_NETWORK_ID]
        if (!network) { network = 'Ganache Blockchain On LAN' }
        reject(`You are NOT connected to the ${network} on which this dApp runs.`)
      }
    })
  }

  getUTF8DataOfResults (state, results) {
    const utf8Results = results.map(result => state.web3.instance().toUtf8(result))
    return {
      name: utf8Results[0],
      email: utf8Results[1],
      phone: utf8Results[2]
    }
  }
}

export default new Auth()
