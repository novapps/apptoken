pragma solidity ^0.4.18;

library UInt16 {

  function toBytes(uint8 a) public pure returns (bytes b) {
    b = new bytes(1);
    b[0] = byte(a);
  }

}