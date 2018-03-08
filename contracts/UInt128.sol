pragma solidity ^0.4.18;

library UInt128 {

  function toBytes(uint128 a) public pure returns (bytes b) {
    b = new bytes(16);
    for (uint i = 0; i < 16; i++) {
      b[i] = byte(uint8(a / (2 ** (8 * (15 - i)))));
    }
  }

}