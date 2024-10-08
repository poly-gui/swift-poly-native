// AUTOMATICALLY GENERATED BY NANOPACK. DO NOT MODIFY BY HAND.

import Foundation
import NanoPack

let Button_typeID: TypeID = 320_412_644

class Button: Widget {
  override var typeID: TypeID { return 320_412_644 }

  override var headerSize: Int { return 16 }

  let text: String
  let onClick: UInt32

  init(tag: UInt32?, text: String, onClick: UInt32) {
    self.text = text
    self.onClick = onClick
    super.init(tag: tag)
  }

  required init?(data: Data) {
    var ptr = data.startIndex + 16

    var tag: UInt32?
    if data.readSize(ofField: 0) < 0 {
      tag = nil
    } else {
      tag = data.read(at: ptr)
      ptr += 4
    }

    let textSize = data.readSize(ofField: 1)
    guard let text = data.read(at: ptr, withLength: textSize) else {
      return nil
    }
    ptr += textSize

    let onClick: UInt32 = data.read(at: ptr)
    ptr += 4

    self.text = text
    self.onClick = onClick
    super.init(tag: tag)
  }

  required init?(data: Data, bytesRead: inout Int) {
    var ptr = data.startIndex + 16

    var tag: UInt32?
    if data.readSize(ofField: 0) < 0 {
      tag = nil
    } else {
      tag = data.read(at: ptr)
      ptr += 4
    }

    let textSize = data.readSize(ofField: 1)
    guard let text = data.read(at: ptr, withLength: textSize) else {
      return nil
    }
    ptr += textSize

    let onClick: UInt32 = data.read(at: ptr)
    ptr += 4

    self.text = text
    self.onClick = onClick
    super.init(tag: tag)

    bytesRead = ptr - data.startIndex
  }

  override func write(to data: inout Data, offset: Int) -> Int {
    let dataCountBefore = data.count

    data.reserveCapacity(offset + 16)

    data.append(typeID: TypeID(Button_typeID))
    data.append([0], count: 3 * 4)

    if let tag = self.tag {
      data.write(size: 4, ofField: 0, offset: offset)
      data.append(int: tag)
    } else {
      data.write(size: -1, ofField: 0, offset: offset)
    }

    data.write(size: text.lengthOfBytes(using: .utf8), ofField: 1, offset: offset)
    data.append(string: text)

    data.write(size: 4, ofField: 2, offset: offset)
    data.append(int: onClick)

    return data.count - dataCountBefore
  }

  override func data() -> Data? {
    var data = Data()
    _ = write(to: &data, offset: 0)
    return data
  }
}
