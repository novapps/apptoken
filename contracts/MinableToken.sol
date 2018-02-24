pragma solidity ^0.4.18;

import "./zeppelin/token/ERC20/StandardToken.sol";
import "./zeppelin/ownership/Ownable.sol";

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
