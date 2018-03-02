<template>
  <div id="web3-message">
    <div class="content">
      <div class="message">
        <div v-if="user.hasWeb3InjectedBrowser">
          <div v-if="user.isConnectedToApprovedNetwork">
            Connected to the {{ approvedNetworkName }} on the blockchain.
            <br>
            <div v-if="user.hasCoinbase">
              <div class="wallet">Account address</div>
              <div class="address">{{ user.coinbase }}</div>
              <div class="token">APPIT</div>
              <div class="balance">{{ user.tokenBalance }}</div>
              <div class="power">APPTP</div>
              <div class="balance">{{ user.powerBalance }}</div>
              <div class="wallet">Mining Earning</div>
              <div class="balance">{{ user.miningEarning }}</div>
            </div>
            <div v-else>
              You don't have an account with us on the blockchain.<br>Or you do but the account is currently inaccessible.<br>Create an account on the blockchain and sign up to begin, or make your existing account accessible.
            </div>
          </div>
          <div v-else>
            But you are not connected to our network on the blockchain [{{ approvedNetworkName }}].<br>
            Connect to the {{ approvedNetworkName }}.
          </div>
        </div>
        <div v-else>
          Your browser is not Web3-injected. To use the dApp, you can install <a href='https://metamask.io/'>Metamask</a>.
          <div class="metamask-resource" @click="goToMetamask"></div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
  export default {
    name: 'web3-message',
    computed: {
      coinbase () {
        return this.user.coinbase
      }
    },
    data: () => {
      return {
        approvedNetworkName: NETWORKS[APPROVED_NETWORK_ID]
      }
    },
    methods: {
      goToMetamask () {
        window.location.href = 'https://metamask.io/'
      }
    },
    props: [ 'user' ]
  }

  import { APPROVED_NETWORK_ID, NETWORKS } from '../../util/constants'
</script>

<style scoped>
  #web3-message {
    width: 100%;
    height: 420px;
  }

  .blockchain-message {
    float: left;
    margin-top: 20px;
    font-size: 14px;
    border: 1px solid #dcdede;
    color: #4d4c49;
    width: auto;
    padding: 10px;
  }

  .wallet {
    font-size: 18px;
    margin-top: 20px;
    color: #c5bb31;
    width: auto;
  }

  .address {
    font-size: 24px;
    margin-top: 20px;
    color: #d69642;
    width: auto;
  }

  .token {
    font-size: 18px;
    margin-top: 20px;
    color: #80178a;
    width: auto;
  }

  .power {
    font-size: 18px;
    margin-top: 20px;
    color: #1b18c2;
    width: auto;
  }

  .balance {
    font-size: 32px;
    margin-top: 20px;
    color: #af161d;
    width: auto;
  }

  .content {
    height: 100%;
    text-align: center;
    max-width: 920px;
    margin: auto;
    padding: 160px;
  }

  .message {
    height: 80px;
    line-height: 40px;
  }

  .metamask-resource {
    background: url('/static/images/metamask.png') no-repeat;
    background-size: contain;
    height: 200px;
    width: auto;
    cursor: pointer;
  }
</style>
