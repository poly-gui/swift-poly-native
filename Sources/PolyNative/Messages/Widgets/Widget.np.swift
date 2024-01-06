// AUTOMATICALLY GENERATED BY NANOPACK. DO NOT MODIFY BY HAND.

import Foundation
import NanoPack

let Widget_typeID: TypeID = 100

class Widget: NanoPackMessage {
  var typeID: TypeID { return 100 }

  let tag: Int32?

  init(tag: Int32?) {
    self.tag = tag
  }

  static func from(data: Data) -> Widget? {
    switch data.readTypeID() {
    case Widget_typeID: return Widget(data: data)
    case Text_typeID: return Text(data: data)
    default: return nil
    }
  }

  required init?(data: Data) {
    var ptr = data.startIndex + 8

    let tag: Int32?
    if data.readSize(ofField: 0) < 0 {
      tag = nil
    } else {
      tag = data.read(at: ptr)
      ptr += 4
    }

    self.tag = tag
  }

  required init?(data: Data, bytesRead: inout Int) {
    var ptr = data.startIndex + 8

    let tag: Int32?
    if data.readSize(ofField: 0) < 0 {
      tag = nil
    } else {
      tag = data.read(at: ptr)
      ptr += 4
    }

    self.tag = tag

    bytesRead = ptr - data.startIndex
  }

  func data() -> Data? {
    var data = Data()
    data.reserveCapacity(8)

    withUnsafeBytes(of: Int32(Widget_typeID)) {
      data.append(contentsOf: $0)
    }

    data.append([0], count: 4)

    if let tag = self.tag {
      data.write(size: 4, ofField: 0)
      data.append(int: tag)
    } else {
      data.write(size: -1, ofField: 0)
    }

    return data
  }
}
