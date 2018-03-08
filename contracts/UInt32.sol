pragma solidity ^0.4.18;

library UInt32 {

  function toBytes(uint32 a) public pure returns (bytes b) {
    b = new bytes(4);
    for (uint i = 0; i < 4; i++) {
      b[i] = byte(uint8(a / (2 ** (8 * (3 - i)))));
    }
  }

}