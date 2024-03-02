// AUTOMATICALLY GENERATED BY NANOPACK. DO NOT MODIFY BY HAND.

import Foundation
import NanoPack

let ListViewDeleteOperation_typeID: TypeID = 2_223_513_129

class ListViewDeleteOperation: ListViewOperation {
  override var typeID: TypeID { return 2_223_513_129 }

  let deleteAt: [Int32]

  init(tag: Int32, deleteAt: [Int32]) {
    self.deleteAt = deleteAt
    super.init(tag: tag)
  }

  required init?(data: Data) {
    var ptr = data.startIndex + 12

    let tag: Int32 = data.read(at: ptr)
    ptr += 4

    let deleteAtByteSize = data.readSize(ofField: 1)
    let deleteAtItemCount = deleteAtByteSize / 4
    let deleteAt = data[ptr..<ptr + deleteAtByteSize].withUnsafeBytes {
      [Int32]($0.bindMemory(to: Int32.self).lazy.map { $0.littleEndian })
    }
    ptr += deleteAtByteSize

    self.deleteAt = deleteAt
    super.init(tag: tag)
  }

  required init?(data: Data, bytesRead: inout Int) {
    var ptr = data.startIndex + 12

    let tag: Int32 = data.read(at: ptr)
    ptr += 4

    let deleteAtByteSize = data.readSize(ofField: 1)
    let deleteAtItemCount = deleteAtByteSize / 4
    let deleteAt = data[ptr..<ptr + deleteAtByteSize].withUnsafeBytes {
      [Int32]($0.bindMemory(to: Int32.self).lazy.map { $0.littleEndian })
    }
    ptr += deleteAtByteSize

    self.deleteAt = deleteAt
    super.init(tag: tag)

    bytesRead = ptr - data.startIndex
  }

  override func data() -> Data? {
    let offset = 0

    var data = Data()
    data.reserveCapacity(12)

    data.append(typeID: TypeID(ListViewDeleteOperation_typeID))
    data.append([0], count: 2 * 4)

    data.write(size: 4, ofField: 0, offset: offset)
    data.append(int: tag)

    data.write(size: deleteAt.count * 4, ofField: 1, offset: offset)
    for i in deleteAt {
      data.append(int: i)
    }

    return data
  }

  override func dataWithLengthPrefix() -> Data? {
    let offset = 4

    var data = Data()
    data.reserveCapacity(12 + 4)

    data.append(int: Int32(0))
    data.append(typeID: TypeID(ListViewDeleteOperation_typeID))
    data.append([0], count: 2 * 4)

    data.write(size: 4, ofField: 0, offset: offset)
    data.append(int: tag)

    data.write(size: deleteAt.count * 4, ofField: 1, offset: offset)
    for i in deleteAt {
      data.append(int: i)
    }

    data.write(size: data.count, at: 0)

    return data
  }
}
