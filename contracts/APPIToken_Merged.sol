pragma solidity ^0.4.18;


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