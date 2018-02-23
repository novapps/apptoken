pragma solidity ^0.4.18;

import "./zeppelin/token/ERC20/CappedToken.sol";
import "./APPIPower.sol";

contract APPIToken is CappedToken {
  string public name = "Application Incentive Token";
  string public symbol = "APPIT";
  uint256 public decimals = 18;

  uint256 public initMiningEarning = 0;
  uint256 public initMiningSpeed = 10 ** decimals;
  uint256 public miningDifficulty = 1;
  uint256 public maxMiningTime = 2 days;

  uint256[] public miningSpeeds = [5 * 10 ** decimals, 10 ** decimals];
  uint256[] public miningSpeedDurations = [2 years, 4 years];

  uint256 public startTime;

  mapping (address => uint256) miningEarnings;
  mapping (address => uint256) lastMineTimes;

  APPIPower internal appiPower;

  event Burn(address indexed burner, uint256 value);
  event Reward(address indexed burner, uint256 value);

  function APPIToken(address _powerContractAddress, uint32 _capBase, uint32 _capDecimals) CappedToken(_capBase * 10 ** (_capDecimals + decimals)) public {
    appiPower = APPIPower(_powerContractAddress);
    startTime = now;
  }

  function setup(string _name, string _symbol, uint256 _decimals) external onlyOwner {
    name = _name;
    symbol = _symbol;
    decimals - _decimals;
  }

  function setupMining(uint256 _initMiningEarning, uint256 _initMiningSpeed, uint256 _maxMiningTime) external onlyOwner {
    initMiningEarning = _initMiningEarning;
    initMiningSpeed = _initMiningSpeed;
    maxMiningTime = _maxMiningTime;
  }

  function setupMiningSpeeds(uint256[] _miningSpeeds, uint256[] _miningSpeedDurations) external onlyOwner {
    require(_miningSpeeds.length > 0 && _miningSpeeds.length == _miningSpeedDurations.length);
    miningSpeeds = _miningSpeeds;
    miningSpeedDurations = _miningSpeedDurations;
  }

  function setPowerContract(address _address) external onlyOwner {
    require(_address != address(0));
    appiPower = APPIPower(_address);
  }

  /**
   * @dev Burns a specific amount of tokens.
   * @param _value The amount of token to be burned.
   */
  function burn(uint256 _value) public onlyOwner {
    require(_value <= balances[msg.sender]);
    // no need to require value <= totalSupply, since that would imply the
    // sender's balance is greater than the totalSupply, which *should* be an assertion failure

    address burner = msg.sender;
    balances[burner] = balances[burner].sub(_value);
    totalSupply_ = totalSupply_.sub(_value);
    Burn(burner, _value);
  }

  function miningSpeed() public view returns (uint256) {
    if (now <= startTime) {
      return initMiningSpeed;
    }
    uint256 duration = now - startTime;
    for (uint i = miningSpeeds.length; i > 0; i--) {
      if (duration >= miningSpeedDurations[i - 1]) {
        return miningSpeeds[i - 1];
      }
    }
    return initMiningSpeed;
  }

  function miningEarning() public view returns (uint256) {
    uint256 lastTime = lastMineTimes[msg.sender];
    require(lastTime < now);
    uint256 earning = 0;
    if (lastTime == 0) {
      earning = initMiningEarning;
    } else {
      uint256 miningTime = now - lastTime;
      if (miningTime > maxMiningTime) {
        miningTime = maxMiningTime;
      }
      earning = miningTime.mul(miningSpeed());
      earning = earning.mul(appiPower.balanceOf(msg.sender)).div(appiPower.totalSupply());
      earning = earning.add(miningEarnings[msg.sender]);
    }
    return earning;
  }

  function mine() public returns (uint256) {
    uint256 earning = miningEarning();
    mint(msg.sender, earning);
    lastMineTimes[msg.sender] = now;
    miningEarnings[msg.sender] = 0;
    return earning;
  }
}