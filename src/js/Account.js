let account = null
class Account {
  constructor () {
    account = account || this
    return account
  }

  list (web3) {
    return new Promise((resolve, reject) => {
      web3.currentProvider.sendAsync({
        jsonrpc: '2.0',
        method: 'personal_listAccounts',
        params: [],
        id: new Date().getSeconds()
      }, (err, resp) => {
        if (!err) {
          resolve(resp.result)
        } else {
          reject(err)
        }
      })
    })
  }

  create (web3, passphrase) {
    return new Promise((resolve, reject) => {
      web3.currentProvider.sendAsync({
        jsonrpc: '2.0',
        method: 'personal_newAccount',
        params: [passphrase],
        id: new Date().getSeconds()
      }, (err, resp) => {
        if (!err) {
          resolve(resp.result)
        } else {
          reject(err)
        }
      })
    })
  }

  unlock (web3, address, passphrase) {
    return new Promise((resolve, reject) => {
      web3.currentProvider.sendAsync({
        jsonrpc: '2.0',
        method: 'personal_unlockAccount',
        params: [
          address,
          passphrase,
          null
        ],
        id: new Date().getSeconds()
      }, (err, resp) => {
        if (!err) {
          resolve(resp.result)
        } else {
          reject(err)
        }
      })
    })
  }

}

export default new Account()
