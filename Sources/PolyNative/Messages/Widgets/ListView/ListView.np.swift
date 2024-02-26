// AUTOMATICALLY GENERATED BY NANOPACK. DO NOT MODIFY BY HAND.

import Foundation
import NanoPack

let ListView_typeID: TypeID = 107

class ListView: Widget {
  override var typeID: TypeID { return 107 }

  let width: Double
  let height: Double
  let sectionCounts: [Int32]
  let renderItem: Int32

  init(tag: Int32?, width: Double, height: Double, sectionCounts: [Int32], renderItem: Int32) {
    self.width = width
    self.height = height
    self.sectionCounts = sectionCounts
    self.renderItem = renderItem
    super.init(tag: tag)
  }

  required init?(data: Data) {
    var ptr = data.startIndex + 24

    var tag: Int32?
    if data.readSize(ofField: 0) < 0 {
      tag = nil
    } else {
      tag = data.read(at: ptr)
      ptr += 4
    }

    let width: Double = data.read(at: ptr)
    ptr += 8

    let height: Double = data.read(at: ptr)
    ptr += 8

    let sectionCountsByteSize = data.readSize(ofField: 3)
    let sectionCountsItemCount = sectionCountsByteSize / 4
    let sectionCounts = data[ptr..<ptr + sectionCountsByteSize].withUnsafeBytes {
      [Int32]($0.bindMemory(to: Int32.self).lazy.map { $0.littleEndian })
    }
    ptr += sectionCountsByteSize

    let renderItem: Int32 = data.read(at: ptr)
    ptr += 4

    self.width = width
    self.height = height
    self.sectionCounts = sectionCounts
    self.renderItem = renderItem
    super.init(tag: tag)
  }

  required init?(data: Data, bytesRead: inout Int) {
    var ptr = data.startIndex + 24

    var tag: Int32?
    if data.readSize(ofField: 0) < 0 {
      tag = nil
    } else {
      tag = data.read(at: ptr)
      ptr += 4
    }

    let width: Double = data.read(at: ptr)
    ptr += 8

    let height: Double = data.read(at: ptr)
    ptr += 8

    let sectionCountsByteSize = data.readSize(ofField: 3)
    let sectionCountsItemCount = sectionCountsByteSize / 4
    let sectionCounts = data[ptr..<ptr + sectionCountsByteSize].withUnsafeBytes {
      [Int32]($0.bindMemory(to: Int32.self).lazy.map { $0.littleEndian })
    }
    ptr += sectionCountsByteSize

    let renderItem: Int32 = data.read(at: ptr)
    ptr += 4

    self.width = width
    self.height = height
    self.sectionCounts = sectionCounts
    self.renderItem = renderItem
    super.init(tag: tag)

    bytesRead = ptr - data.startIndex
  }

  override func data() -> Data? {
    let offset = 0

    var data = Data()
    data.reserveCapacity(24)

    data.append(int: Int32(ListView_typeID))
    data.append([0], count: 5 * 4)

    if let tag = self.tag {
      data.write(size: 4, ofField: 0, offset: offset)
      data.append(int: tag)
    } else {
      data.write(size: -1, ofField: 0, offset: offset)
    }

    data.write(size: 8, ofField: 1, offset: offset)
    data.append(double: width)

    data.write(size: 8, ofField: 2, offset: offset)
    data.append(double: height)

    data.write(size: sectionCounts.count * 4, ofField: 3, offset: offset)
    for i in sectionCounts {
      data.append(int: i)
    }

    data.write(size: 4, ofField: 4, offset: offset)
    data.append(int: renderItem)

    return data
  }

  override func dataWithLengthPrefix() -> Data? {
    let offset = 4

    var data = Data()
    data.reserveCapacity(24 + 4)

    data.append(int: Int32(0))
    data.append(int: Int32(ListView_typeID))
    data.append([0], count: 5 * 4)

    if let tag = self.tag {
      data.write(size: 4, ofField: 0, offset: offset)
      data.append(int: tag)
    } else {
      data.write(size: -1, ofField: 0, offset: offset)
    }

    data.write(size: 8, ofField: 1, offset: offset)
    data.append(double: width)

    data.write(size: 8, ofField: 2, offset: offset)
    data.append(double: height)

    data.write(size: sectionCounts.count * 4, ofField: 3, offset: offset)
    for i in sectionCounts {
      data.append(int: i)
    }

    data.write(size: 4, ofField: 4, offset: offset)
    data.append(int: renderItem)

    data.write(size: data.count, at: 0)

    return data
  }
}
