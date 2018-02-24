import contract from 'truffle-contract'
import APPIToken from '../../build/contracts/APPIToken.json'
import { APPROVED_NETWORK_ID, NETWORKS } from '../util/constants'

let appit = null
class APPIT {
  constructor () {
    appit = appit || this
    return appit
  }

  getBalance (state = null, data = {}) {
    return new Promise((resolve, reject) => {
      this.accessAPPITokenContractWith({
        state,
        method: (contractInstance, coinbase) => {
          return new Promise((resolve, reject) => {
            contractInstance.getBalance({ from: coinbase }).then((result) => {
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

  getMiningEarning (state = null, data = {}) {
    return new Promise((resolve, reject) => {
      this.accessAPPITokenContractWith({
        state,
        method: (contractInstance, coinbase) => {
          return new Promise((resolve, reject) => {
            contractInstance.getMiningEarning({ from: coinbase }).then((result) => {
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

  accessAPPITokenContractWith (dataObject = {}) {
    const state = dataObject.state
    return new Promise((resolve, reject) => {
      if (!state || !state.web3 || !(state.web3.instance)) {
        reject('Web3 is not initialised. Use a Web3 injector')
      } else if (state.web3.networkId) {
        let tokenContract = contract(APPIToken)
        tokenContract.setProvider(state.web3.instance().currentProvider)
        state.web3.instance().eth.getCoinbase((err, coinbase) => {
          if (err) {
            console.error(':::Unable to get coinbase for this operation')
            reject(err)
          } else {
            tokenContract.deployed().then((contractInstance) => {
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

}

export default new APPIT()
