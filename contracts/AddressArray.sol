pragma solidity ^0.4.18;

library AddressArray {

  function toBytes(address a) public pure returns (bytes b) {
    assembly {
      let m := mload(0x40)
      mstore(add(m, 20), xor(0x140000000000000000000000000000000000000000, a))
      mstore(0x40, add(m, 52))
      b := m
    }
  }

  function toBytes(address[] storage _arr, uint256 _from, uint256 _to) public view returns (bytes b) {
    uint256 size = 20 * (_to - _from + 1);
    uint256 index = 0;
    b = new bytes(size);
    for (uint256 i = _from; i < _to + 1; i++) {
        bytes memory elem = toBytes(_arr[i]);
        for (uint j = 0; j < 20; j++) {
            b[index++] = elem[j];
        }
    }
    return b;
  }

}