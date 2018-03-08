pragma solidity ^0.4.18;

library UInt16 {

  function toBytes(uint16 a) public pure returns (bytes b) {
    b = new bytes(2);
    for (uint i = 0; i < 2; i++) {
      b[i] = byte(uint8(a / (2 ** (8 * (1 - i)))));
    }
  }

}