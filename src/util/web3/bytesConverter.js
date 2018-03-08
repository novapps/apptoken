import {BigNumber} from 'bignumber'

let converter = null
class BytesConverter {
  constructor () {
    converter = converter || this
    return converter
  }

  stripHexPrefix (str) {
    return str.startsWith('0x') ? str.slice(2) : str
  }
  
  // Convert byte string to int array.
  toInt256Array (bytes) {
    let stripped = stripHexPrefix(bytes)
    return stripped.match(/.{1,64}/g).map(s => new BigNumber('0x' + s))
  }
    
  // Convert byte string to int array.
  toInt128Array (bytes) {
    let stripped = stripHexPrefix(bytes)
    return stripped.match(/.{1,32}/g).map(s => new BigNumber('0x' + s))
  }
  
  // Convert byte string to int array.
  toInt64Array (bytes) {
    let stripped = stripHexPrefix(bytes)
    return stripped.match(/.{1,16}/g).map(s => new BigNumber('0x' + s))
  }
  
  // Convert byte string to int array.
  toInt32Array (bytes) {
    let stripped = stripHexPrefix(bytes)
    return stripped.match(/.{1,8}/g).map(s => parseInt('0x' + s))
  }
  
  // Convert byte string to int array.
  toInt16Array (bytes) {
    let stripped = stripHexPrefix(bytes)
    return stripped.match(/.{1,4}/g).map(s => parseInt('0x' + s))
  }
  
  // Convert byte string to int array.
  toInt8Array (bytes) {
    let stripped = stripHexPrefix(bytes)
    return stripped.match(/.{1,2}/g).map(s => parseInt('0x' + s))
  }

  // Convert byte string to address array
  toAddressArray (bytes) {
    let stripped = stripHexPrefix(bytes)
    return stripped.match(/.{1,40}/g).map(s => '0x' + s)
  }

  toStringArray (bytes) {
    let stripped = stripHexPrefix(bytes);
    let result = [];
    var cursor = 0;
    while (cursor < bytes.length) {
      let next = cursor + 2
      if (next > bytes.length) {
        break;
      }
      let length = parseInt('0x' + bytes.substring(cursor, next))
      cursor = next
      next = cursor + length
      if (next > bytes.length) {
        break;
      }
      str = bytes.substring(cursor, next)
      cursor = next
      result.push(str)
    }
    return result
  }
}

export default new BytesConverter()
