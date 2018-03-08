pragma solidity ^0.4.18;

library String {

  function toBytes(string a) public pure returns (bytes b) {
    bytes memory str = bytes(a);
    require(str.length < 256);
    b = new bytes(str.length + 1);
    b[0] = byte(uint8(str.length));
    for (uint i = 0; i < str.length; i++) {
      b[i + 1] = str[i];
    }
  }

}