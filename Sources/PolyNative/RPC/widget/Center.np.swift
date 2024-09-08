// AUTOMATICALLY GENERATED BY NANOPACK. DO NOT MODIFY BY HAND.

import Foundation
import NanoPack

let Center_typeID: TypeID = 1_855_640_887

class Center: Widget {
  override var typeID: TypeID { return 1_855_640_887 }

  override var headerSize: Int { return 12 }

  let child: Widget

  init(tag: UInt32?, child: Widget) {
    self.child = child
    super.init(tag: tag)
  }

  required init?(data: Data) {
    var ptr = data.startIndex + 12

    var tag: UInt32?
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

    var tag: UInt32?
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

  override func write(to data: inout Data, offset: Int) -> Int {
    let dataCountBefore = data.count

    data.reserveCapacity(offset + 12)

    data.append(typeID: TypeID(Center_typeID))
    data.append([0], count: 2 * 4)

    if let tag = self.tag {
      data.write(size: 4, ofField: 0, offset: offset)
      data.append(int: tag)
    } else {
      data.write(size: -1, ofField: 0, offset: offset)
    }

    let childByteSize = child.write(to: &data, offset: data.count)
    data.write(size: childByteSize, ofField: 1, offset: offset)

    return data.count - dataCountBefore
  }

  override func data() -> Data? {
    var data = Data()
    _ = write(to: &data, offset: 0)
    return data
  }
}