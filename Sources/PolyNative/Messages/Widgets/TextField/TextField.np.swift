// AUTOMATICALLY GENERATED BY NANOPACK. DO NOT MODIFY BY HAND.

import Foundation
import NanoPack

let TextField_typeID: TypeID = 105

class TextField: Widget {
  override var typeID: TypeID { return 105 }

  let placeholder: String?
  let value: String
  let onValueChanged: Int32

  init(tag: Int32?, placeholder: String?, value: String, onValueChanged: Int32) {
    self.placeholder = placeholder
    self.value = value
    self.onValueChanged = onValueChanged
    super.init(tag: tag)
  }

  required init?(data: Data) {
    var ptr = data.startIndex + 20

    var tag: Int32?
    if data.readSize(ofField: 0) < 0 {
      tag = nil
    } else {
      tag = data.read(at: ptr)
      ptr += 4
    }

    var placeholder: String?
    if data.readSize(ofField: 1) < 0 {
      placeholder = nil
    } else {
      let placeholderSize = data.readSize(ofField: 1)
      guard let placeholder_ = data.read(at: ptr, withLength: placeholderSize) else {
        return nil
      }
      placeholder = placeholder_
      ptr += placeholderSize
    }

    let valueSize = data.readSize(ofField: 2)
    guard let value = data.read(at: ptr, withLength: valueSize) else {
      return nil
    }
    ptr += valueSize

    let onValueChanged: Int32 = data.read(at: ptr)
    ptr += 4

    self.placeholder = placeholder
    self.value = value
    self.onValueChanged = onValueChanged
    super.init(tag: tag)
  }

  required init?(data: Data, bytesRead: inout Int) {
    var ptr = data.startIndex + 20

    var tag: Int32?
    if data.readSize(ofField: 0) < 0 {
      tag = nil
    } else {
      tag = data.read(at: ptr)
      ptr += 4
    }

    var placeholder: String?
    if data.readSize(ofField: 1) < 0 {
      placeholder = nil
    } else {
      let placeholderSize = data.readSize(ofField: 1)
      guard let placeholder_ = data.read(at: ptr, withLength: placeholderSize) else {
        return nil
      }
      placeholder = placeholder_
      ptr += placeholderSize
    }

    let valueSize = data.readSize(ofField: 2)
    guard let value = data.read(at: ptr, withLength: valueSize) else {
      return nil
    }
    ptr += valueSize

    let onValueChanged: Int32 = data.read(at: ptr)
    ptr += 4

    self.placeholder = placeholder
    self.value = value
    self.onValueChanged = onValueChanged
    super.init(tag: tag)

    bytesRead = ptr - data.startIndex
  }

  override func data() -> Data? {
    let offset = 0

    var data = Data()
    data.reserveCapacity(20)

    data.append(int: Int32(TextField_typeID))
    data.append([0], count: 4 * 4)

    if let tag = self.tag {
      data.write(size: 4, ofField: 0, offset: offset)
      data.append(int: tag)
    } else {
      data.write(size: -1, ofField: 0, offset: offset)
    }

    if let placeholder = self.placeholder {
      data.write(size: placeholder.lengthOfBytes(using: .utf8), ofField: 1, offset: offset)
      data.append(string: placeholder)
    } else {
      data.write(size: -1, ofField: 1, offset: offset)
    }

    data.write(size: value.lengthOfBytes(using: .utf8), ofField: 2, offset: offset)
    data.append(string: value)

    data.write(size: 4, ofField: 3, offset: offset)
    data.append(int: onValueChanged)

    return data
  }

  override func dataWithLengthPrefix() -> Data? {
    let offset = 4

    var data = Data()
    data.reserveCapacity(20 + 4)

    data.append(int: Int32(0))
    data.append(int: Int32(TextField_typeID))
    data.append([0], count: 4 * 4)

    if let tag = self.tag {
      data.write(size: 4, ofField: 0, offset: offset)
      data.append(int: tag)
    } else {
      data.write(size: -1, ofField: 0, offset: offset)
    }

    if let placeholder = self.placeholder {
      data.write(size: placeholder.lengthOfBytes(using: .utf8), ofField: 1, offset: offset)
      data.append(string: placeholder)
    } else {
      data.write(size: -1, ofField: 1, offset: offset)
    }

    data.write(size: value.lengthOfBytes(using: .utf8), ofField: 2, offset: offset)
    data.append(string: value)

    data.write(size: 4, ofField: 3, offset: offset)
    data.append(int: onValueChanged)

    data.write(size: data.count, at: 0)

    return data
  }
}
