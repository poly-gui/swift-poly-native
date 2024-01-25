// AUTOMATICALLY GENERATED BY NANOPACK. DO NOT MODIFY BY HAND.

import Foundation
import NanoPack

let InvokeCallback_typeID: TypeID = 2

class InvokeCallback: NanoPackMessage {
  var typeID: TypeID { return 2 }

  let handle: Int32
  let args: Data

  init(handle: Int32, args: Data) {
    self.handle = handle
    self.args = args
  }

  required init?(data: Data) {
    var ptr = data.startIndex + 12

    let handle: Int32 = data.read(at: ptr)
    ptr += 4

    let argsByteSize = data.readSize(ofField: 1)
    let args = data[ptr..<ptr + argsByteSize]
    ptr += argsByteSize

    self.handle = handle
    self.args = args
  }

  required init?(data: Data, bytesRead: inout Int) {
    var ptr = data.startIndex + 12

    let handle: Int32 = data.read(at: ptr)
    ptr += 4

    let argsByteSize = data.readSize(ofField: 1)
    let args = data[ptr..<ptr + argsByteSize]
    ptr += argsByteSize

    self.handle = handle
    self.args = args

    bytesRead = ptr - data.startIndex
  }

  func data() -> Data? {
    var data = Data()
    data.reserveCapacity(12)

    withUnsafeBytes(of: Int32(InvokeCallback_typeID)) {
      data.append(contentsOf: $0)
    }

    data.append([0], count: 2 * 4)

    data.write(size: 4, ofField: 0)
    data.append(int: handle)

    data.write(size: args.count, ofField: 1)
    data.append(args)

    return data
  }
}
