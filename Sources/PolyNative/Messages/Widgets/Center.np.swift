// AUTOMATICALLY GENERATED BY NANOPACK. DO NOT MODIFY BY HAND.

import Foundation
import NanoPack

let Center_typeID: TypeID = 102

class Center: Widget {
  override var typeID: TypeID { return 102 }

  let child: Widget

  init(tag: Int32?, child: Widget) {
    self.child = child
    super.init(tag: tag)
  }

  required init?(data: Data) {
    var ptr = data.startIndex + 12

    var tag: Int32?
    if data.readSize(ofField: 0) < 0 {
      tag = nil
    } else {
      tag = data.read(at: ptr)
      ptr += 4
    }

    let childByteSize = data.readSize(ofField: 1)
    guard let child = Widget.from(data: data[ptr...]) else {
      return nil
    }
    ptr += childByteSize

    self.child = child
    super.init(tag: tag)
  }

  required init?(data: Data, bytesRead: inout Int) {
    var ptr = data.startIndex + 12

    var tag: Int32?
    if data.readSize(ofField: 0) < 0 {
      tag = nil
    } else {
      tag = data.read(at: ptr)
      ptr += 4
    }

    let childByteSize = data.readSize(ofField: 1)
    guard let child = Widget.from(data: data[ptr...]) else {
      return nil
    }
    ptr += childByteSize

    self.child = child
    super.init(tag: tag)

    bytesRead = ptr - data.startIndex
  }

  override func data() -> Data? {
    var data = Data()
    data.reserveCapacity(12)

    withUnsafeBytes(of: Int32(Center_typeID)) {
      data.append(contentsOf: $0)
    }

    data.append([0], count: 2 * 4)

    if let tag = self.tag {
      data.write(size: 4, ofField: 0)
      data.append(int: tag)
    } else {
      data.write(size: -1, ofField: 0)
    }

    guard let childData = child.data() else {
      return nil
    }
    data.write(size: childData.count, ofField: 1)
    data.append(childData)

    return data
  }
}
