// AUTOMATICALLY GENERATED BY NANOPACK. DO NOT MODIFY BY HAND.

import Foundation
import NanoPack

let ListViewBatchOperations_typeID: TypeID = 3_604_546_751

class ListViewBatchOperations: NanoPackMessage {
  var typeID: TypeID { return 3_604_546_751 }

  var headerSize: Int { return 8 }

  let operations: [ListViewOperation]

  init(operations: [ListViewOperation]) {
    self.operations = operations
  }

  required init?(data: Data) {
    var ptr = data.startIndex + 8

    let operationsItemCount = data.readSize(at: ptr)
    ptr += 4
    var operations: [ListViewOperation] = []
    operations.reserveCapacity(operationsItemCount)
    for _ in 0..<operationsItemCount {
      var iItemByteSize = 0
      guard let iItem = ListViewOperation.from(data: data[ptr...], bytesRead: &iItemByteSize) else {
        return nil
      }
      ptr += iItemByteSize
      operations.append(iItem)
    }

    self.operations = operations
  }

  required init?(data: Data, bytesRead: inout Int) {
    var ptr = data.startIndex + 8

    let operationsItemCount = data.readSize(at: ptr)
    ptr += 4
    var operations: [ListViewOperation] = []
    operations.reserveCapacity(operationsItemCount)
    for _ in 0..<operationsItemCount {
      var iItemByteSize = 0
      guard let iItem = ListViewOperation.from(data: data[ptr...], bytesRead: &iItemByteSize) else {
        return nil
      }
      ptr += iItemByteSize
      operations.append(iItem)
    }

    self.operations = operations

    bytesRead = ptr - data.startIndex
  }

  func write(to data: inout Data, offset: Int) -> Int {
    let dataCountBefore = data.count

    data.reserveCapacity(offset + 8)

    data.append(typeID: TypeID(ListViewBatchOperations_typeID))
    data.append([0], count: 1 * 4)

    data.append(size: operations.count)
    var operationsByteSize: Size = 4
    for i in operations {
      let iByteSize = i.write(to: &data, offset: data.count)
      operationsByteSize += iByteSize
    }
    data.write(size: operationsByteSize, ofField: 0, offset: offset)

    return data.count - dataCountBefore
  }

  func data() -> Data? {
    var data = Data()
    _ = write(to: &data, offset: 0)
    return data
  }
}
