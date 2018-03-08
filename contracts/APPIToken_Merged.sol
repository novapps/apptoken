pragma solidity ^0.4.20;

// 0x130b31F22C5715c6da97B7BE0Fee174ba91794F0

/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
  address public owner;


  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);


  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  function Ownable() public {
    owner = msg.sender;
  }

  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to.
   */
  function transferOwnership(address newOwner) public onlyOwner {
    require(newOwner != address(0));
    OwnershipTransferred(owner, newOwner);
    owner = newOwner;
  }

}


/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {

  /**
  * @dev Multiplies two numbers, throws on overflow.
  */
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }
    uint256 c = a * b;
    assert(c / a == b);
    return c;
  }

  /**
  * @dev Integer division of two numbers, truncating the quotient.
  */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  /**
  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  /**
  * @dev Adds two numbers, throws on overflow.
  */
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
}


/**
 * @title ERC20Basic
 * @dev Simpler version of ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/179
 */
contract ERC20Basic {
  function totalSupply() public view returns (uint256);
  function balanceOf(address who) public view returns (uint256);
  function transfer(address to, uint256 value) public returns (bool);
  event Transfer(address indexed from, address indexed to, uint256 value);
}


/**
 * @title ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
contract ERC20 is ERC20Basic {
  function allowance(address owner, address spender) public view returns (uint256);
  function transferFrom(address from, address to, uint256 value) public returns (bool);
  function approve(address spender, uint256 value) public returns (bool);
  event Approval(address indexed owner, address indexed spender, uint256 value);
}


/**
 * @title Basic token
 * @dev Basic version of StandardToken, with no allowances.
 */
contract BasicToken is ERC20Basic {
  using SafeMath for uint256;

  mapping(address => uint256) balances;

  uint256 totalSupply_;

  /**
  * @dev total number of tokens in existence
  */
  function totalSupply() public view returns (uint256) {
    return totalSupply_;
  }

  /**
  * @dev transfer token for a specified address
  * @param _to The address to transfer to.
  * @param _value The amount to be transferred.
  */
  function transfer(address _to, uint256 _value) public returns (bool) {
    require(_to != address(0));
    require(_value <= balances[msg.sender]);

    // SafeMath.sub will throw if there is not enough balance.
    balances[msg.sender] = balances[msg.sender].sub(_value);
    balances[_to] = balances[_to].add(_value);
    Transfer(msg.sender, _to, _value);
    return true;
  }

  /**
  * @dev Gets the balance of the specified address.
  * @param _owner The address to query the the balance of.
  * @return An uint256 representing the amount owned by the passed address.
  */
  function balanceOf(address _owner) public view returns (uint256 balance) {
    return balances[_owner];
  }

}


/**
 * @title Standard ERC20 token
 *
 * @dev Implementation of the basic standard token.
 * @dev https://github.com/ethereum/EIPs/issues/20
 * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
 */
contract StandardToken is ERC20, BasicToken {

  mapping (address => mapping (address => uint256)) internal allowed;


  /**
   * @dev Transfer tokens from one address to another
   * @param _from address The address which you want to send tokens from
   * @param _to address The address which you want to transfer to
   * @param _value uint256 the amount of tokens to be transferred
   */
  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
    require(_to != address(0));
    require(_value <= balances[_from]);
    require(_value <= allowed[_from][msg.sender]);

    balances[_from] = balances[_from].sub(_value);
    balances[_to] = balances[_to].add(_value);
    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
    Transfer(_from, _to, _value);
    return true;
  }

  /**
   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
   *
   * Beware that changing an allowance with this method brings the risk that someone may use both the old
   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
   * @param _spender The address which will spend the funds.
   * @param _value The amount of tokens to be spent.
   */
  function approve(address _spender, uint256 _value) public returns (bool) {
    allowed[msg.sender][_spender] = _value;
    Approval(msg.sender, _spender, _value);
    return true;
  }

  /**
   * @dev Function to check the amount of tokens that an owner allowed to a spender.
   * @param _owner address The address which owns the funds.
   * @param _spender address The address which will spend the funds.
   * @return A uint256 specifying the amount of tokens still available for the spender.
   */
  function allowance(address _owner, address _spender) public view returns (uint256) {
    return allowed[_owner][_spender];
  }

  /**
   * @dev Increase the amount of tokens that an owner allowed to a spender.
   *
   * approve should be called when allowed[_spender] == 0. To increment
   * allowed value is better to use this function to avoid 2 calls (and wait until
   * the first transaction is mined)
   * From MonolithDAO Token.sol
   * @param _spender The address which will spend the funds.
   * @param _addedValue The amount of tokens to increase the allowance by.
   */
  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }

  /**
   * @dev Decrease the amount of tokens that an owner allowed to a spender.
   *
   * approve should be called when allowed[_spender] == 0. To decrement
   * allowed value is better to use this function to avoid 2 calls (and wait until
   * the first transaction is mined)
   * From MonolithDAO Token.sol
   * @param _spender The address which will spend the funds.
   * @param _subtractedValue The amount of tokens to decrease the allowance by.
   */
  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
    uint oldValue = allowed[msg.sender][_spender];
    if (_subtractedValue > oldValue) {
      allowed[msg.sender][_spender] = 0;
    } else {
      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
    }
    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }

}


contract MinableToken is StandardToken, Ownable {
  event Mine(address indexed to, uint256 amount);
  event MiningFinished();

  uint256 public cap;
  bool public miningFinished = false;

  modifier canMine() {
    require(!miningFinished && (cap == 0 || totalSupply_ < cap));
    _;
  }

  function MinableToken(uint256 _cap) public {
    cap = _cap;
  }

  function mine(address _to, uint256 _amount) canMine internal returns (bool) {
    if (cap > 0 && totalSupply_.add(_amount) > cap) {
      _amount = cap.sub(totalSupply_);
    }
    totalSupply_ = totalSupply_.add(_amount);
    balances[_to] = balances[_to].add(_amount);
    Mine(_to, _amount);
    Transfer(address(0), _to, _amount);
    return true;
  }

  /**
   * @dev Function to stop minting new tokens.
   * @return True if the operation was successful.
   */
  function finishMining() onlyOwner canMine public {
    miningFinished = true;
    MiningFinished();
  }
}


contract AppManager is Ownable {

  struct Manager {
    uint32 index;
    bytes32 name;
  }

  mapping(address => Manager) private managers;
  address[] private managerAddresses;

  event AddManager(address indexed _address, uint32 _index, bytes32 _name);
  event RemoveManager(address indexed _address, uint32 _index, bytes32 _name);
  event UpdateManager(address indexed _address, uint32 _index, bytes32 _name);

  function AppManager() public {
    addManager(msg.sender, "__OWNER__");
  }

  function checkManager(address _address) internal view returns (bool) {
    if (managerAddresses.length == 0) return false;
    return managerAddresses[managers[_address].index] == _address;
  }

  modifier onlyManager() {
    require(checkManager(msg.sender));
    _;
  }

  function isManager(address _address) external view returns (bool) {
    return checkManager(_address);
  }

  function addManager(address _address, bytes32 _name) public onlyOwner {
    require(!checkManager(_address));
    uint32 index = uint32(managerAddresses.push(_address) - 1);
    managers[_address] = Manager(index, _name);
    AddManager(_address, index, _name);
    managerAddresses.push(_address);
  }

  function removeManager(address _address) public onlyOwner {
    require(checkManager(_address));
    uint32 index = managers[_address].index;
    bytes32 name = managers[_address].name;
    address last = managerAddresses[managerAddresses.length - 1];
    managerAddresses[index] = last;
    managers[last].index = index;
    managerAddresses.length--;
    RemoveManager(_address, index, name);
    UpdateManager(last, index, managers[last].name);
    delete managers[_address];
  }

  function updateManager(address _address, bytes32 _name) public onlyOwner {
    require(checkManager(_address));
    managers[_address].name = _name;
    UpdateManager(_address, managers[_address].index, _name);
  }

  function getManagerCount() external view onlyOwner returns (uint32) {
    return uint32(managerAddresses.length);
  }

  function getManager(address _address) external view onlyOwner returns (uint32, bytes32) {
    require(checkManager(_address));
    return (managers[_address].index, managers[_address].name);
  }

  function getManagerAt(uint32 _index) external view onlyOwner returns (address, uint32, bytes32) {
    address managerAddress = managerAddresses[_index];
    require(checkManager(managerAddress));
    return (managerAddress, managers[managerAddress].index, managers[managerAddress].name);
  }

}


contract AppDeveloper is AppManager {

  struct Developer {
    uint32 index;
    bytes32 name;
  }
  
  mapping(address => Developer) private developers;
  address[] private developerAddresses;

  event AddDeveloper(address indexed _address, uint32 _index, bytes32 _name);
  event RemoveDeveloper(address indexed _address, uint32 _index, bytes32 _name);
  event UpdateDeveloper(address indexed _address, uint32 _index, bytes32 _name);

  function checkDeveloper(address _address) internal view returns (bool) {
    if (developerAddresses.length == 0) return false;
    return developerAddresses[developers[_address].index] == _address;
  }

  modifier onlyDeveloper() {
    require(checkDeveloper(msg.sender));
    _;
  }

  function isDeveloper(address _address) external view returns (bool) {
    return checkDeveloper(_address);
  }

  function addDeveloper(address _address, bytes32 _name) public onlyManager {
    require(!checkDeveloper(_address));
    uint32 index = uint32(developerAddresses.push(_address) - 1);
    developers[_address] = Developer(index, _name);
    AddDeveloper(_address, index, _name);
    developerAddresses.push(_address);
  }

  function removeDeveloper(address _address) public onlyManager {
    require(checkDeveloper(_address));
    uint32 index = developers[_address].index;
    bytes32 name = developers[_address].name;
    address last = developerAddresses[developerAddresses.length - 1];
    developerAddresses[index] = last;
    developers[last].index = index;
    developerAddresses.length--;
    RemoveDeveloper(_address, index, name);
    UpdateDeveloper(last, index, developers[last].name);
    delete developers[_address];
  }

  function updateDeveloper(address _address, bytes32 _name) public onlyManager {
    require(checkDeveloper(_address));
    developers[_address].name = _name;
    UpdateDeveloper(_address, developers[_address].index, _name);
  }

  function getDeveloperCount() external view onlyManager returns (uint32) {
    return uint32(developerAddresses.length);
  }

  function getDeveloper(address _address) external view onlyManager returns (uint32, bytes32) {
    require(checkDeveloper(_address));
    return (developers[_address].index, developers[_address].name);
  }

  function getDeveloperAt(uint32 _index) external view onlyManager returns (address, uint32, bytes32) {
    address developerAddress = developerAddresses[_index];
    require(checkDeveloper(developerAddress));
    return (developerAddress, developers[developerAddress].index, developers[developerAddress].name);
  }
  
}


contract APPIPower is AppDeveloper {
  using SafeMath for uint256;
  
  uint256 initPower;
  uint256 powerSupply;
  mapping(address => uint256) powers;
  bool mintingFinished = false;

  struct TaskConfig {
    uint32 oneOffQuota;
    uint32 dailyQuota;
  }

  mapping (address => TaskConfig) private taskConfigs;

  mapping (address => uint8[]) private oneOffTaskLists;
  mapping (address => uint8[]) private dailyTaskLists;

  mapping (address => bool[]) oneOffTasks;
  mapping (address => uint[]) dailyTasks;

  event MintFinished();
  event MintPower(address indexed to, uint256 amount);

  event UpdateTaskConfig(address _developer, uint32 _oneOffQuota, uint32 _dailyQuota);
  event UpdateOneOffTaskList(address _developer, uint8[] _powers);
  event UpdateDailyTaskList(address _developer, uint8[] _powers);
  event RewardFromOneOffTask(address _user, address _developer, uint _index, uint8 _power);
  event RewardFromDailyTask(address _user, address _developer, uint _index, uint8 _power);

  function APPIPower(uint32 _initPower, uint32 _reservedPower) public {
    initPower = _initPower;
    powerSupply = _reservedPower;
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

  modifier canMint() {
    require(!mintingFinished);
    _;
  }

  function finishMinting() onlyOwner canMint public {
    mintingFinished = true;
    MintFinished();
  }

  function mintPower(address _to, uint256 _amount) internal canMint {
    powerSupply = powerSupply.add(_amount);
    powers[_to] = powers[_to].add(_amount);
    MintPower(_to, _amount);
  }

  function setTaskConfig(address _developer, uint32 _oneOffQuota, uint32 _dailyQuota) public onlyManager {
    require(checkDeveloper(_developer));
    taskConfigs[_developer].oneOffQuota = _oneOffQuota;
    taskConfigs[_developer].dailyQuota = _dailyQuota;
    UpdateTaskConfig(_developer, _oneOffQuota, _dailyQuota);
  }

  function checkQuota(uint8[] _powers, uint32 _quota) internal pure returns (bool) {
    uint32 quota = 0;
    for (uint i = 0; i < _powers.length; i++) {
      quota += _powers[i];
    }
    return (quota <= _quota);
  }

  modifier underOneOffQuota(uint8[] _powers) {
    require(checkDeveloper(msg.sender) && checkQuota(_powers, taskConfigs[msg.sender].oneOffQuota));
    _;
  }

  modifier underDailyQuota(uint8[] _powers) {
    require(checkDeveloper(msg.sender) && checkQuota(_powers, taskConfigs[msg.sender].dailyQuota));
    _;
  }

  function setupOneOffTaskList(uint8[] powerRewards) public underOneOffQuota(powerRewards) {
    oneOffTaskLists[msg.sender] = powerRewards;
    UpdateOneOffTaskList(msg.sender, powerRewards);
  }

  function setupDailyTaskList(uint8[] powerRewards) public underDailyQuota(powerRewards) {
    dailyTaskLists[msg.sender] = powerRewards;
    UpdateDailyTaskList(msg.sender, powerRewards);
  }

  function rewardFromOneOffTask(address _developer, uint _index) public {
    require(checkDeveloper(_developer));
    require(_index < oneOffTaskLists[_developer].length);
    if (oneOffTasks[msg.sender].length == 0) {
      oneOffTasks[msg.sender].length = oneOffTaskLists[_developer].length;
    }
    require(!oneOffTasks[msg.sender][_index]);
    uint8 powerReward = oneOffTaskLists[_developer][_index];
    mintPower(msg.sender, powerReward);
    oneOffTasks[msg.sender][_index] = true;
    RewardFromOneOffTask(msg.sender, _developer, _index, powerReward);
  }

  function rewardFromDailyTask(address _developer, uint _index) public {
    require(checkDeveloper(_developer));
    require(_index < dailyTaskLists[_developer].length);
    if (dailyTasks[msg.sender].length == 0) {
      dailyTasks[msg.sender].length = dailyTaskLists[_developer].length;
    }
    uint today = now / 1 days;
    require(dailyTasks[msg.sender][_index] < today);
    uint8 powerReward = dailyTaskLists[_developer][_index];
    mintPower(msg.sender, powerReward);
    dailyTasks[msg.sender][_index] = today;
    RewardFromDailyTask(msg.sender, _developer, _index, powerReward);
  }

}


contract APPIToken is APPIPower, MinableToken {
  string name = "Application Incentive Token";
  string symbol = "APPIT";
  uint256 decimals = 18;

  uint256 initMiningEarning = 0;
  uint256 initMiningSpeed = 10 ** decimals;
  uint256 miningDifficulty = 1;
  uint256 maxMiningTime = 2 days;

  uint256[] miningSpeeds = [5 * 10 ** decimals, 10 ** decimals];
  uint256[] miningSpeedDurations = [2 years, 4 years];

  uint256 startTime;

  mapping (address => uint256) miningEarnings;
  mapping (address => uint256) lastMiningTimes;

  event Burn(address indexed burner, uint256 value);
  event Mine(address indexed miner, uint256 value);

  function APPIToken(uint32 _capBase, uint32 _capDecimals, uint32 _initPower, uint32 _reservedPower)
    APPIPower(_initPower, _reservedPower)
    MinableToken(_capBase * 10 ** (_capDecimals + decimals))
    public {
    startTime = now;
  }

  function setup(string _name, string _symbol, uint256 _decimals)
    external onlyOwner {
    name = _name;
    symbol = _symbol;
    decimals - _decimals;
  }

  function setupMining(uint256 _initMiningEarning, uint256 _initMiningSpeed, uint256 _maxMiningTime)
    external onlyOwner {
    initMiningEarning = _initMiningEarning;
    initMiningSpeed = _initMiningSpeed;
    maxMiningTime = _maxMiningTime;
  }

  function setupMiningSpeeds(uint256[] _miningSpeeds, uint256[] _miningSpeedDurations)
    external onlyOwner {
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