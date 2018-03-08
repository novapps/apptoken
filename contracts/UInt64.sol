pragma solidity ^0.4.18;

library UInt64 {

  function toBytes(uint64 a) public pure returns (bytes b) {
    b = new bytes(8);
    for (uint i = 0; i < 8; i++) {
      b[i] = byte(uint8(a / (2 ** (8 * (7 - i)))));
    }
  }

}