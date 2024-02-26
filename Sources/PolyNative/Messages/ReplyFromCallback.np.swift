// AUTOMATICALLY GENERATED BY NANOPACK. DO NOT MODIFY BY HAND.

import Foundation
import NanoPack

let ReplyFromCallback_typeID: TypeID = 5

class ReplyFromCallback: NanoPackMessage {
  var typeID: TypeID { return 5 }

  let to: Int32
  let args: Data

  init(to: Int32, args: Data) {
    self.to = to
    self.args = args
  }

  required init?(data: Data) {
    var ptr = data.startIndex + 12

    let to: Int32 = data.read(at: ptr)
    ptr += 4

    let argsByteSize = data.readSize(ofField: 1)
    let args = data[ptr..<ptr + argsByteSize]
    ptr += argsByteSize

    self.to = to
    self.args = args
  }

  required init?(data: Data, bytesRead: inout Int) {
    var ptr = data.startIndex + 12

    let to: Int32 = data.read(at: ptr)
    ptr += 4

    let argsByteSize = data.readSize(ofField: 1)
    let args = data[ptr..<ptr + argsByteSize]
    ptr += argsByteSize

    self.to = to
    self.args = args

    bytesRead = ptr - data.startIndex
  }

  func data() -> Data? {
    let offset = 0

    var data = Data()
    data.reserveCapacity(12)

    data.append(int: Int32(ReplyFromCallback_typeID))
    data.append([0], count: 2 * 4)

    data.write(size: 4, ofField: 0, offset: offset)
    data.append(int: to)

    data.write(size: args.count, ofField: 1, offset: offset)
    data.append(args)

    return data
  }

  func dataWithLengthPrefix() -> Data? {
    let offset = 4

    var data = Data()
    data.reserveCapacity(12 + 4)

    data.append(int: Int32(0))
    data.append(int: Int32(ReplyFromCallback_typeID))
    data.append([0], count: 2 * 4)

    data.write(size: 4, ofField: 0, offset: offset)
    data.append(int: to)

    data.write(size: args.count, ofField: 1, offset: offset)
    data.append(args)

    data.write(size: data.count, at: 0)

    return data
  }
}
