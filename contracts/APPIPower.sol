pragma solidity ^0.4.18;

import "./zeppelin/token/ERC20/MintableToken.sol";

contract APPIPower is MintableToken {
  string public name = "Application Incentive Power";
  string public symbol = "APPIP";
  uint256 public decimals = 18;

  function APPIPower(uint256 _reserved) public {
    mint(msg.sender, _reserved);
  }

  function setup(string _name, string _symbol, uint256 _decimals) public onlyOwner {
    name = _name;
    symbol = _symbol;
    decimals - _decimals;
  }
   
  function getTotalSupply() external view returns (uint256) {
    return totalSupply();
  }

  function getBalance() external view returns (uint256) {
    return balanceOf(msg.sender);
  }
}