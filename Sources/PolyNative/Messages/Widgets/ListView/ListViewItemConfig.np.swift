// AUTOMATICALLY GENERATED BY NANOPACK. DO NOT MODIFY BY HAND.

import Foundation
import NanoPack

let ListViewItemConfig_typeID: TypeID = 4_128_951_807

class ListViewItemConfig: NanoPackMessage {
  var typeID: TypeID { return 4_128_951_807 }

  var headerSize: Int { return 16 }

  let sectionIndex: UInt32?
  let itemIndex: UInt32?
  let itemTag: UInt32?

  init(sectionIndex: UInt32?, itemIndex: UInt32?, itemTag: UInt32?) {
    self.sectionIndex = sectionIndex
    self.itemIndex = itemIndex
    self.itemTag = itemTag
  }

  required init?(data: Data) {
    var ptr = data.startIndex + 16

    var sectionIndex: UInt32?
    if data.readSize(ofField: 0) < 0 {
      sectionIndex = nil
    } else {
      sectionIndex = data.read(at: ptr)
      ptr += 4
    }

    var itemIndex: UInt32?
    if data.readSize(ofField: 1) < 0 {
      itemIndex = nil
    } else {
      itemIndex = data.read(at: ptr)
      ptr += 4
    }

    var itemTag: UInt32?
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

    var sectionIndex: UInt32?
    if data.readSize(ofField: 0) < 0 {
      sectionIndex = nil
    } else {
      sectionIndex = data.read(at: ptr)
      ptr += 4
    }

    var itemIndex: UInt32?
    if data.readSize(ofField: 1) < 0 {
      itemIndex = nil
    } else {
      itemIndex = data.read(at: ptr)
      ptr += 4
    }

    var itemTag: UInt32?
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

  func write(to data: inout Data, offset: Int) -> Int {
    let dataCountBefore = data.count

    data.reserveCapacity(offset + 16)

    data.append(typeID: TypeID(ListViewItemConfig_typeID))
    data.append([0], count: 3 * 4)

    if let sectionIndex = self.sectionIndex {
      data.write(size: 4, ofField: 0, offset: offset)
      data.append(int: sectionIndex)
    } else {
      data.write(size: -1, ofField: 0, offset: offset)
    }

    if let itemIndex = self.itemIndex {
      data.write(size: 4, ofField: 1, offset: offset)
      data.append(int: itemIndex)
    } else {
      data.write(size: -1, ofField: 1, offset: offset)
    }

    if let itemTag = self.itemTag {
      data.write(size: 4, ofField: 2, offset: offset)
      data.append(int: itemTag)
    } else {
      data.write(size: -1, ofField: 2, offset: offset)
    }

    return data.count - dataCountBefore
  }

  func data() -> Data? {
    var data = Data()
    _ = write(to: &data, offset: 0)
    return data
  }
}
