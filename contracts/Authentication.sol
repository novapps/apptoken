pragma solidity ^0.4.18;

import './zeppelin/lifecycle/Destructible.sol';

contract Authentication is Destructible {
  struct User {
    bytes32 name;
    bytes32 email;
    bytes32 phone;
  }

  event SignedUp(address indexed _userAddress, bytes32 _name, bytes32 indexed _email, bytes32 indexed _phone);
  event Updated(address indexed _userAddress, bytes32 _name, bytes32 indexed _email, bytes32 indexed _phone);
  mapping (address => User) private users;
  address[] usersArray;

  uint private id; // Stores user id temporarily

  modifier onlyExistingUser {
    // Check if user exists or terminate

    require(users[msg.sender].name != 0x0 && users[msg.sender].email != 0x0 && users[msg.sender].phone != 0x0);
    _;
  }

  modifier onlyValidName(bytes32 _name) {
    // Only valid names allowed

    require(!(_name == 0x0));
    _;
  }

  modifier onlyValidEmail(bytes32 _email) {
    // Only valid emails allowed

    require(!(_email == 0x0));
    _;
  }

  modifier onlyValidPhone(bytes32 _phone) {
    // Only valid phone numbers allowed

    require(!(_phone == 0x0));
    _;
  }

  function login() external view onlyExistingUser returns (bytes32, bytes32, bytes32) {
    return (users[msg.sender].name, users[msg.sender].email, users[msg.sender].phone);
  }

  function signup(bytes32 _name, bytes32 _email, bytes32 _phone) external payable
    onlyValidName(_name)
    onlyValidEmail(_email)
    onlyValidPhone(_phone)
    returns (bytes32, bytes32, bytes32)
  {
    if (users[msg.sender].name == 0x0 && users[msg.sender].email == 0x0 && users[msg.sender].phone == 0x0) {
      users[msg.sender] = User(_name, _email, _phone);
    } else {
      if (users[msg.sender].name == 0x0) {users[msg.sender].name = _name;}
      if (users[msg.sender].email == 0x0) {users[msg.sender].email = _email;}
      if (users[msg.sender].phone == 0x0) {users[msg.sender].phone = _phone;}
    }
    SignedUp(msg.sender, _name, _email, _phone);
    return (users[msg.sender].name, users[msg.sender].email, users[msg.sender].phone);
  }

  function update(bytes32 _name, bytes32 _email, bytes32 _phone) external payable
    onlyValidName(_name)
    onlyValidEmail(_email)
    onlyValidPhone(_phone)
    onlyExistingUser
    returns (bytes32, bytes32, bytes32)
  {
    users[msg.sender].name = _name;
    users[msg.sender].email = _email;
    users[msg.sender].phone = _phone;
    Updated(msg.sender, _name, _email, _phone);
    return (_name, _email, _phone);
  }
}
