pragma solidity ^0.4.18;

library UInt256 {

  function toBytes(uint256 a) public pure returns (bytes b) {
    b = new bytes(32);
    for (uint i = 0; i < 32; i++) {
      b[i] = byte(uint8(a / (2 ** (8 * (31 - i)))));
    }
  }

}