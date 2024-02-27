// AUTOMATICALLY GENERATED BY NANOPACK. DO NOT MODIFY BY HAND.

import Foundation
import NanoPack

let Widget_typeID: TypeID = 100

class Widget: NanoPackMessage {
  var typeID: TypeID { return 100 }

  let tag: Int32?

  static func from(data: Data) -> Widget? {
    switch data.readTypeID() {
    case 100: return Widget(data: data)
    case 102: return Center(data: data)
    case 105: return TextField(data: data)
    case 107: return ListView(data: data)
    case 103: return Column(data: data)
    case 104: return Button(data: data)
    case 101: return Text(data: data)
    case 106: return Row(data: data)
    default: return nil
    }
  }

  static func from(data: Data, bytesRead: inout Int) -> Widget? {
    switch data.readTypeID() {
    case 100: return Widget(data: data, bytesRead: &bytesRead)
    case 102: return Center(data: data, bytesRead: &bytesRead)
    case 105: return TextField(data: data, bytesRead: &bytesRead)
    case 107: return ListView(data: data, bytesRead: &bytesRead)
    case 103: return Column(data: data, bytesRead: &bytesRead)
    case 104: return Button(data: data, bytesRead: &bytesRead)
    case 101: return Text(data: data, bytesRead: &bytesRead)
    case 106: return Row(data: data, bytesRead: &bytesRead)
    default: return nil
    }
  }

  init(tag: Int32?) {
    self.tag = tag
  }

  required init?(data: Data) {
    var ptr = data.startIndex + 8

    var tag: Int32?
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

    var tag: Int32?
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
    let offset = 0

    var data = Data()
    data.reserveCapacity(8)

    data.append(int: Int32(Widget_typeID))
    data.append([0], count: 1 * 4)

    if let tag = self.tag {
      data.write(size: 4, ofField: 0, offset: offset)
      data.append(int: tag)
    } else {
      data.write(size: -1, ofField: 0, offset: offset)
    }

    return data
  }

  func dataWithLengthPrefix() -> Data? {
    let offset = 4

    var data = Data()
    data.reserveCapacity(8 + 4)

    data.append(int: Int32(0))
    data.append(int: Int32(Widget_typeID))
    data.append([0], count: 1 * 4)

    if let tag = self.tag {
      data.write(size: 4, ofField: 0, offset: offset)
      data.append(int: tag)
    } else {
      data.write(size: -1, ofField: 0, offset: offset)
    }

    data.write(size: data.count, at: 0)

    return data
  }
}
