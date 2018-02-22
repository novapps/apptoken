<template>
  <div id="footer-template">
    <div class="content">
      <div class="links">
        <a href="http://novapps.com" target="_blank" class="logo"></a>
        <a href="https://github.com/novapps" target="_blank" class="github"></a>
        <a href="https://facebook.com/novapps" target="_blank" class="facebook"></a>
        <a href="https://twitter.com/novapps" target="_blank" class="twitter"></a>
      </div>
    </div>
  </div>
</template>

<script type="text/javascript">
  export default {
    name: 'footer-template'
  }
</script>

<style scoped>
  #footer-template {
    width: 100%;
    background: #bababa;
    color: #1d1e1f;
    height: 80px;
    position: fixed;
    bottom: 0;
    min-width: 700px
  }

  .content {
    height: 100%;
    max-width: 920px;
    margin: auto;
    text-align: center;
    padding: 25px 0px;
  }

  .links {
    clear: both;
    height: 30px;
  }

  .links a {
    color: inherit;
    text-decoration: none;
  }

  .divider {
    color: inherit;
  }

  .divider:before {
    content: "|"
  }

  .copyright {
    clear: both;
    height: 20px;
    font-size: 14px;
  }

  .copyleft-resource {
    background: url('/static/images/copyleft.png') no-repeat;
    height: 20px;
    width: 20px;
    display: inline-block;
    background-size: contain;
  }

  .logo {
    display: inline-block;
    width: 30px;
    height: 30px;
    background: url('/static/images/logo.png') no-repeat;
    background-size: contain;
  }

  .github {
    display: inline-block;
    width: 30px;
    height: 30px;
    margin: 0px 0px 0px 30px;
    background: url('/static/images/github.png') no-repeat;
    background-size: contain;
  }

  .facebook {
    display: inline-block;
    width: 30px;
    height: 30px;
    margin: 0px 0px 0px 30px;
    background: url('/static/images/facebook.png') no-repeat;
    background-size: contain;
  }

  .twitter {
    display: inline-block;
    width: 30px;
    height: 30px;
    margin: 0px 0px 0px 30px;
    background: url('/static/images/twitter.png') no-repeat;
    background-size: contain;
  }
</style>
