import contract from 'truffle-contract'
import APPIToken from '../../build/contracts/APPIToken.json'
import { APPROVED_NETWORK_ID, NETWORKS } from '../util/constants'

let appit = null
class APPIT {
  constructor () {
    appit = appit || this
    return appit
  }

  getTotalSupply (web3, coinbase) {
    return new Promise((resolve, reject) => {
      this.accessAPPIPowerContractWith({
        web3,
        callback: (contractInstance) => {
          return new Promise((resolve, reject) => {
            contractInstance.getTotalSupply({ from: coinbase }).then((result) => {
              console.log('tokenTotalSupply: ' + result)
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
      this.accessAPPITokenContractWith({
        web3,
        callback: (contractInstance) => {
          return new Promise((resolve, reject) => {
            contractInstance.getBalance({ from: coinbase }).then((result) => {
              console.log('tokenBalance: ' + result)
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

  getPower (web3, coinbase) {
    return new Promise((resolve, reject) => {
      this.accessAPPITokenContractWith({
        web3,
        callback: (contractInstance) => {
          return new Promise((resolve, reject) => {
            contractInstance.getPower({ from: coinbase }).then((result) => {
              console.log('power: ' + result)
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

  getMiningSpeed (web3, coinbase) {
    return new Promise((resolve, reject) => {
      this.accessAPPITokenContractWith({
        web3,
        callback: (contractInstance) => {
          return new Promise((resolve, reject) => {
            contractInstance.getMiningSpeed({ from: coinbase }).then((result) => {
              console.log('miningSpeed: ' + result)
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

  getMiningEarning (web3, coinbase) {
    return new Promise((resolve, reject) => {
      this.accessAPPITokenContractWith({
        web3,
        callback: (contractInstance) => {
          return new Promise((resolve, reject) => {
            contractInstance.getMiningEarning({ from: coinbase }).then((result) => {
              console.log('miningEarning: ' + result)
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

  mine (web3, coinbase) {
    return new Promise((resolve, reject) => {
      this.accessAPPITokenContractWith({
        web3,
        callback: (contractInstance) => {
          return new Promise((resolve, reject) => {
            contractInstance.mine({ from: coinbase, gas: 4444444 }).then((result) => {
              contractInstance.getBalance({ from: coinbase }).then((result) => {
                console.log('token after minning: ' + result)
                resolve(result)
              }).catch((e) => {
                reject(e)
              })
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

  accessAPPITokenContractWith (params = {}) {
    const web3 = params.web3
    return new Promise((resolve, reject) => {
      if (!web3) {
        reject('Web3 is not initialised. Use a Web3 injector')
      } else if (web3.networkId) {
        let tokenContract = contract(APPIToken)
        tokenContract.setProvider(web3.currentProvider)
        tokenContract.deployed().then((contractInstance) => {
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

export default new APPIT()
