import contract from 'truffle-contract'
// import APPIToken from '../../build/contracts/APPIToken.json'
import TokenABI from '../../build/APPIToken.json'
const TokenAddress = '0x3158CC29483Ab7822a46718B7b2190f4105Ef7C3'

let appit = null
class APPIT {
  constructor () {
    appit = appit || this
    return appit
  }

  accessAPPITokenContractWith (params = {}) {
    const web3 = params.web3
    return new Promise((resolve, reject) => {
      if (!web3) {
        reject('Web3 is not initialised. Use a Web3 injector')
      } else {
        let tokenContract = contract({contractName: 'APPIToken', abi: TokenABI})
        tokenContract.setProvider(web3.currentProvider)
        web3.eth.getCoinbase((err, coinbase) => {
          if (err) {
            console.error(':::Unable to get coinbase for this operation')
            reject(err)
          } else {
            tokenContract.at(TokenAddress).then((contractInstance) => {
              params.callback(contractInstance, coinbase).then((result) => {
                resolve(result)
              }).catch((err) => {
                reject(err)
              })
            }).catch((err) => {
              reject(err)
            })
          }
        })
      }
    })
  }

  getTotalSupply (web3) {
    return new Promise((resolve, reject) => {
      this.accessAPPIPowerContractWith({
        web3,
        callback: (contractInstance, coinbase) => {
          return new Promise((resolve, reject) => {
            contractInstance.getTotalSupply({ from: coinbase }).then((result) => {
              let supply = web3.fromWei(result.toNumber(), 'ether')
              console.log('tokenTotalSupply: ' + supply)
              resolve(supply)
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

  getBalance (web3) {
    return new Promise((resolve, reject) => {
      this.accessAPPITokenContractWith({
        web3,
        callback: (contractInstance, coinbase) => {
          return new Promise((resolve, reject) => {
            contractInstance.getBalance({ from: coinbase }).then((result) => {
              let balance = web3.fromWei(result.toNumber(), 'ether')
              console.log('tokenBalance: ' + balance)
              resolve(balance)
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

  getPower (web3) {
    return new Promise((resolve, reject) => {
      this.accessAPPITokenContractWith({
        web3,
        callback: (contractInstance, coinbase) => {
          return new Promise((resolve, reject) => {
            contractInstance.getPower({ from: coinbase }).then((result) => {
              let power = result.toNumber()
              console.log('power: ' + power)
              resolve(power)
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

  getStartTime (web3) {
    return new Promise((resolve, reject) => {
      this.accessAPPITokenContractWith({
        web3,
        callback: (contractInstance, coinbase) => {
          return new Promise((resolve, reject) => {
            contractInstance.getStartTime({ from: coinbase }).then((result) => {
              let time = result.toNumber()
              console.log('startTime: ' + time)
              resolve(time)
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

  getTimeNow (web3) {
    return new Promise((resolve, reject) => {
      this.accessAPPITokenContractWith({
        web3,
        callback: (contractInstance, coinbase) => {
          return new Promise((resolve, reject) => {
            contractInstance.getTimeNow({ from: coinbase }).then((result) => {
              let now = result.toNumber()
              console.log('now: ' + now)
              resolve(now)
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

  getMiningSpeed (web3) {
    return new Promise((resolve, reject) => {
      this.accessAPPITokenContractWith({
        web3,
        callback: (contractInstance, coinbase) => {
          return new Promise((resolve, reject) => {
            contractInstance.getMiningSpeed({ from: coinbase }).then((result) => {
              let speed = web3.fromWei(result.toNumber(), 'ether')
              console.log('miningSpeed: ' + speed)
              resolve(speed)
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

  getLastMiningTime (web3) {
    return new Promise((resolve, reject) => {
      this.accessAPPITokenContractWith({
        web3,
        callback: (contractInstance, coinbase) => {
          return new Promise((resolve, reject) => {
            contractInstance.getLastMiningTime({ from: coinbase }).then((result) => {
              let time = result.toNumber()
              console.log('lastMiningTime: ' + time)
              resolve(time)
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

  getMiningTime (web3) {
    return new Promise((resolve, reject) => {
      this.accessAPPITokenContractWith({
        web3,
        callback: (contractInstance, coinbase) => {
          return new Promise((resolve, reject) => {
            contractInstance.getMiningTime({ from: coinbase }).then((result) => {
              let time = result.toNumber()
              console.log('miningTime: ' + time)
              resolve(time)
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

  getMiningEarning (web3) {
    return new Promise((resolve, reject) => {
      this.accessAPPITokenContractWith({
        web3,
        callback: (contractInstance, coinbase) => {
          return new Promise((resolve, reject) => {
            contractInstance.getMiningEarning({ from: coinbase }).then((result) => {
              let earning = web3.fromWei(result.toNumber(), 'ether')
              console.log('miningEarning: ' + earning)
              resolve(earning)
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

  mine (web3) {
    return new Promise((resolve, reject) => {
      this.accessAPPITokenContractWith({
        web3,
        callback: (contractInstance, coinbase) => {
          return new Promise((resolve, reject) => {
            contractInstance.mine({ from: coinbase, gas: 4444444, gasPrice: 200000000 }).then((result) => {
              contractInstance.getBalance({ from: coinbase }).then((result) => {
                let balance = web3.fromWei(result.toNumber(), 'ether')
                console.log('token after minning: ' + balance)
                resolve(balance)
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

}

export default new APPIT()
