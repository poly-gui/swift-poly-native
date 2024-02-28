// AUTOMATICALLY GENERATED BY NANOPACK. DO NOT MODIFY BY HAND.

import Foundation
import NanoPack

let Row_typeID: TypeID = 1_006_836_449

class Row: Widget {
  override var typeID: TypeID { return 1_006_836_449 }

  let width: Double
  let height: Double
  let horizontalAlignment: Alignment
  let verticalAlignment: Alignment
  let children: [Widget]

  init(
    tag: Int32?, width: Double, height: Double, horizontalAlignment: Alignment,
    verticalAlignment: Alignment, children: [Widget]
  ) {
    self.width = width
    self.height = height
    self.horizontalAlignment = horizontalAlignment
    self.verticalAlignment = verticalAlignment
    self.children = children
    super.init(tag: tag)
  }

  required init?(data: Data) {
    var ptr = data.startIndex + 28

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

    let horizontalAlignmentRawValue: Int8 = data.read(at: ptr)
    ptr += 1
    guard let horizontalAlignment = Alignment(rawValue: horizontalAlignmentRawValue) else {
      return nil
    }

    let verticalAlignmentRawValue: Int8 = data.read(at: ptr)
    ptr += 1
    guard let verticalAlignment = Alignment(rawValue: verticalAlignmentRawValue) else {
      return nil
    }

    let childrenItemCount = data.readSize(at: ptr)
    ptr += 4
    var children: [Widget] = []
    children.reserveCapacity(childrenItemCount)
    for _ in 0..<childrenItemCount {
      var iItemByteSize = 0
      guard let iItem = Widget.from(data: data[ptr...], bytesRead: &iItemByteSize) else {
        return nil
      }
      ptr += iItemByteSize
      children.append(iItem)
    }

    self.width = width
    self.height = height
    self.horizontalAlignment = horizontalAlignment
    self.verticalAlignment = verticalAlignment
    self.children = children
    super.init(tag: tag)
  }

  required init?(data: Data, bytesRead: inout Int) {
    var ptr = data.startIndex + 28

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

    let horizontalAlignmentRawValue: Int8 = data.read(at: ptr)
    ptr += 1
    guard let horizontalAlignment = Alignment(rawValue: horizontalAlignmentRawValue) else {
      return nil
    }

    let verticalAlignmentRawValue: Int8 = data.read(at: ptr)
    ptr += 1
    guard let verticalAlignment = Alignment(rawValue: verticalAlignmentRawValue) else {
      return nil
    }

    let childrenItemCount = data.readSize(at: ptr)
    ptr += 4
    var children: [Widget] = []
    children.reserveCapacity(childrenItemCount)
    for _ in 0..<childrenItemCount {
      var iItemByteSize = 0
      guard let iItem = Widget.from(data: data[ptr...], bytesRead: &iItemByteSize) else {
        return nil
      }
      ptr += iItemByteSize
      children.append(iItem)
    }

    self.width = width
    self.height = height
    self.horizontalAlignment = horizontalAlignment
    self.verticalAlignment = verticalAlignment
    self.children = children
    super.init(tag: tag)

    bytesRead = ptr - data.startIndex
  }

  override func data() -> Data? {
    let offset = 0

    var data = Data()
    data.reserveCapacity(28)

    data.append(typeID: TypeID(Row_typeID))
    data.append([0], count: 6 * 4)

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

    data.write(size: 1, ofField: 3, offset: offset)
    data.append(int: horizontalAlignment.rawValue)

    data.write(size: 1, ofField: 4, offset: offset)
    data.append(int: verticalAlignment.rawValue)

    data.append(size: children.count)
    var childrenByteSize: Size = 4
    for i in children {
      guard let iData = i.data() else {
        return nil
      }
      data.append(iData)
      childrenByteSize += iData.count
    }
    data.write(size: childrenByteSize, ofField: 5, offset: offset)

    return data
  }

  override func dataWithLengthPrefix() -> Data? {
    let offset = 4

    var data = Data()
    data.reserveCapacity(28 + 4)

    data.append(int: Int32(0))
    data.append(typeID: TypeID(Row_typeID))
    data.append([0], count: 6 * 4)

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

    data.write(size: 1, ofField: 3, offset: offset)
    data.append(int: horizontalAlignment.rawValue)

    data.write(size: 1, ofField: 4, offset: offset)
    data.append(int: verticalAlignment.rawValue)

    data.append(size: children.count)
    var childrenByteSize: Size = 4
    for i in children {
      guard let iData = i.data() else {
        return nil
      }
      data.append(iData)
      childrenByteSize += iData.count
    }
    data.write(size: childrenByteSize, ofField: 5, offset: offset)

    data.write(size: data.count, at: 0)

    return data
  }
}
