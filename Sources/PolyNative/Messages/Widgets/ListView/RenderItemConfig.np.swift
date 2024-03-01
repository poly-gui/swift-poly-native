// AUTOMATICALLY GENERATED BY NANOPACK. DO NOT MODIFY BY HAND.

import Foundation
import NanoPack

let RenderItemConfig_typeID: TypeID = 3_591_753_548

class RenderItemConfig: NanoPackMessage {
  var typeID: TypeID { return 3_591_753_548 }

  let sectionIndex: Int32
  let itemIndex: Int32
  let itemTag: Int32?

  init(sectionIndex: Int32, itemIndex: Int32, itemTag: Int32?) {
    self.sectionIndex = sectionIndex
    self.itemIndex = itemIndex
    self.itemTag = itemTag
  }

  required init?(data: Data) {
    var ptr = data.startIndex + 16

    let sectionIndex: Int32 = data.read(at: ptr)
    ptr += 4

    let itemIndex: Int32 = data.read(at: ptr)
    ptr += 4

    var itemTag: Int32?
    if data.readSize(ofField: 2) < 0 {
      itemTag = nil
    } else {
      itemTag = data.read(at: ptr)
      ptr += 4
    }

    self.sectionIndex = sectionIndex
    self.itemIndex = itemIndex
    self.itemTag = itemTag
  }

  required init?(data: Data, bytesRead: inout Int) {
    var ptr = data.startIndex + 16

    let sectionIndex: Int32 = data.read(at: ptr)
    ptr += 4

    let itemIndex: Int32 = data.read(at: ptr)
    ptr += 4

    var itemTag: Int32?
    if data.readSize(ofField: 2) < 0 {
      itemTag = nil
    } else {
      itemTag = data.read(at: ptr)
      ptr += 4
    }

    self.sectionIndex = sectionIndex
    self.itemIndex = itemIndex
    self.itemTag = itemTag

    bytesRead = ptr - data.startIndex
  }

  func data() -> Data? {
    let offset = 0

    var data = Data()
    data.reserveCapacity(16)

    data.append(typeID: TypeID(RenderItemConfig_typeID))
    data.append([0], count: 3 * 4)

    data.write(size: 4, ofField: 0, offset: offset)
    data.append(int: sectionIndex)

    data.write(size: 4, ofField: 1, offset: offset)
    data.append(int: itemIndex)

    if let itemTag = self.itemTag {
      data.write(size: 4, ofField: 2, offset: offset)
      data.append(int: itemTag)
    } else {
      data.write(size: -1, ofField: 2, offset: offset)
    }

    return data
  }

  func dataWithLengthPrefix() -> Data? {
    let offset = 4

    var data = Data()
    data.reserveCapacity(16 + 4)

    data.append(int: Int32(0))
    data.append(typeID: TypeID(RenderItemConfig_typeID))
    data.append([0], count: 3 * 4)

    data.write(size: 4, ofField: 0, offset: offset)
    data.append(int: sectionIndex)

    data.write(size: 4, ofField: 1, offset: offset)
    data.append(int: itemIndex)

    if let itemTag = self.itemTag {
      data.write(size: 4, ofField: 2, offset: offset)
      data.append(int: itemTag)
    } else {
      data.write(size: -1, ofField: 2, offset: offset)
    }

    data.write(size: data.count, at: 0)

    return data
  }
}
