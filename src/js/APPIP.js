import contract from 'truffle-contract'
import APPIPower from '../../build/contracts/APPIPower.json'
import { APPROVED_NETWORK_ID, NETWORKS } from '../util/constants'

let appip = null
class APPIP {
  constructor () {
    appip = appip || this
    return appip
  }

  getTotalSupply (web3, coinbase) {
    return new Promise((resolve, reject) => {
      this.accessAPPIPowerContractWith({
        web3,
        callback: (contractInstance) => {
          return new Promise((resolve, reject) => {
            contractInstance.getTotalSupply({ from: coinbase }).then((result) => {
              console.log('powerTotalSupply: ' + result)
              resolve(result)
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

  getBalance (web3, coinbase) {
    return new Promise((resolve, reject) => {
      this.accessAPPIPowerContractWith({
        web3,
        callback: (contractInstance) => {
          return new Promise((resolve, reject) => {
            contractInstance.getBalance({ from: coinbase }).then((result) => {
              console.log('powerBalance: ' + result)
              resolve(result)
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

  accessAPPIPowerContractWith (params = {}) {
    const web3 = params.web3
    return new Promise((resolve, reject) => {
      if (!web3) {
        reject('Web3 is not initialised. Use a Web3 injector')
      } else if (web3.networkId) {
        let powerContract = contract(APPIPower)
        powerContract.setProvider(web3.currentProvider)
        powerContract.deployed().then((contractInstance) => {
          params.callback(contractInstance).then((result) => {
            resolve(result)
          }).catch((err) => {
            reject(err)
          })
        }).catch((err) => {
          reject(err)
        })
      } else {
        var network = NETWORKS[APPROVED_NETWORK_ID]
        if (!network) { network = 'Ganache Blockchain On LAN' }
        reject(`You are NOT connected to the ${network} on which this dApp runs.`)
      }
    })
  }

}

export default new APPIP()
