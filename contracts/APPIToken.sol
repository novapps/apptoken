pragma solidity ^0.4.18;

import "./MinableToken.sol";
import "./APPIPower.sol";

contract APPIToken is MinableToken {
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

  uint256 initPower;
  uint256 powerSupply;
  mapping(address => uint256) powers;

  mapping (address => uint256) miningEarnings;
  mapping (address => uint256) lastMiningTimes;

  event Burn(address indexed burner, uint256 value);
  event Mine(address indexed miner, uint256 value);
  event MintPower(address indexed to, uint256 amount);
  event TransferPower(address indexed from, address indexed to, uint256 value);

  function APPIToken(uint32 _capBase, uint32 _capDecimals, uint32 _initPower, uint32 _reservedPower) MinableToken(_capBase * 10 ** (_capDecimals + decimals)) public {
    startTime = now;
    initPower = _initPower;
    powerSupply = _reservedPower;
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

  function getTotalSupply() external view returns (uint256) {
    return totalSupply();
  }

  function getBalance() external view returns (uint256) {
    return balanceOf(msg.sender);
  }

  function transferPower(address _to, uint256 _value) public returns (bool) {
    require(_to != address(0));
    require(_value <= powers[msg.sender]);
    powers[msg.sender] = powers[msg.sender].sub(_value);
    powers[_to] = powers[_to].add(_value);
    TransferPower(msg.sender, _to, _value);
    return true;
  }

  function powerOf(address _owner) public view returns (uint256) {
    return powers[_owner];
  }

  function getPowerSupply() external view returns (uint256) {
    return powerSupply;
  }

  function getPower() external view returns (uint256) {
    return powerOf(msg.sender);
  }

  function mintPower(address _to, uint256 _amount) internal returns (bool) {
    powerSupply = powerSupply.add(_amount);
    powers[_to] = powers[_to].add(_amount);
    MintPower(_to, _amount);
    TransferPower(address(0), _to, _amount);
    return true;
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

  function getStartTime() external view returns (uint256) {
    return startTime;
  }

  function getTimeNow() external view returns (uint256) {
    return now;
  }

  function miningSpeedOf(address _owner) public view returns (uint256) {
    uint256 speed = initMiningSpeed;
    if (now > startTime) {
      uint256 duration = now - startTime;
      for (uint i = miningSpeeds.length; i > 0; i--) {
        if (duration >= miningSpeedDurations[i - 1]) {
          speed = miningSpeeds[i - 1];
          break;
        }
      }
    }
    return speed.mul(powerOf(_owner)).div(powerSupply);
  }

  function getMiningSpeed() external view returns (uint256) {
    return miningSpeedOf(msg.sender);
  }

  function lastMiningTimeOf(address _owner) public view returns (uint256) {
    return lastMiningTimes[_owner];
  }

  function getLastMiningTime() external view returns (uint256) {
    return lastMiningTimeOf(msg.sender);
  }

  function miningTimeOf(address _owner) public view returns (uint256) {
    uint256 lastTime = lastMiningTimes[_owner];
    require(lastTime <= now);
    uint256 miningTime = now - lastTime;
    if (miningTime > maxMiningTime) {
      miningTime = maxMiningTime;
    }
    return miningTime;
  }

  function getMiningTime() external view returns (uint256) {
    return miningTimeOf(msg.sender);
  }

  function miningEarningOf(address _owner) public view returns (uint256) {
    uint256 lastTime = lastMiningTimes[_owner];
    uint256 earning = 0;
    if (lastTime == 0) {
      earning = initMiningEarning;
    } else {
      uint256 miningSpeed = miningSpeedOf(_owner);
      uint256 miningTime = miningTimeOf(_owner);
      earning = miningEarnings[_owner].add(miningSpeed.mul(miningTime));
    }
    return earning;
  }

  function getMiningEarning() external view returns (uint256) {
    return miningEarningOf(msg.sender);
  }

  function mine() external returns (uint256) {
    if (powerOf(msg.sender) == 0) {
      mintPower(msg.sender, initPower);
    }
    uint256 earning = miningEarningOf(msg.sender);
    mine(msg.sender, earning);
    lastMiningTimes[msg.sender] = now;
    miningEarnings[msg.sender] = 0;
    return balanceOf(msg.sender);
  }
}