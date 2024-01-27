// AUTOMATICALLY GENERATED BY NANOPACK. DO NOT MODIFY BY HAND.

import Foundation
import NanoPack

let Button_typeID: TypeID = 104

class Button: Widget {
  override var typeID: TypeID { return 104 }

  let text: String
  let onClick: Int32

  init(tag: Int32?, text: String, onClick: Int32) {
    self.text = text
    self.onClick = onClick
    super.init(tag: tag)
  }

  required init?(data: Data) {
    var ptr = data.startIndex + 16

    var tag: Int32?
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

    let onClick: Int32 = data.read(at: ptr)
    ptr += 4

    self.text = text
    self.onClick = onClick
    super.init(tag: tag)
  }

  required init?(data: Data, bytesRead: inout Int) {
    var ptr = data.startIndex + 16

    var tag: Int32?
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

    let onClick: Int32 = data.read(at: ptr)
    ptr += 4

    self.text = text
    self.onClick = onClick
    super.init(tag: tag)

    bytesRead = ptr - data.startIndex
  }

  override func data() -> Data? {
    var data = Data()
    data.reserveCapacity(16)

    withUnsafeBytes(of: Int32(Button_typeID)) {
      data.append(contentsOf: $0)
    }

    data.append([0], count: 3 * 4)

    if let tag = self.tag {
      data.write(size: 4, ofField: 0)
      data.append(int: tag)
    } else {
      data.write(size: -1, ofField: 0)
    }

    data.write(size: text.lengthOfBytes(using: .utf8), ofField: 1)
    data.append(string: text)

    data.write(size: 4, ofField: 2)
    data.append(int: onClick)

    return data
  }
}