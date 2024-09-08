// AUTOMATICALLY GENERATED BY NANOPACK. DO NOT MODIFY BY HAND.

import Foundation
import NanoPack

let Widget_typeID: TypeID = 1_676_374_721

class Widget: NanoPackMessage {
  var typeID: TypeID { return 1_676_374_721 }

  var headerSize: Int { return 8 }

  let tag: UInt32?

  static func from(data: Data) -> Widget? {
    switch data.readTypeID() {
    case 1_676_374_721: return Widget(data: data)
    case 320_412_644: return Button(data: data)
    case 841_129_444: return TextField(data: data)
    case 1_006_836_449: return Row(data: data)
    case 1_855_640_887: return Center(data: data)
    case 2_164_488_861: return ListView(data: data)
    case 2_415_007_766: return Column(data: data)
    case 3_373_588_321: return Slider(data: data)
    case 3_495_336_243: return Text(data: data)
    default: return nil
    }
  }

  static func from(data: Data, bytesRead: inout Int) -> Widget? {
    switch data.readTypeID() {
    case 1_676_374_721: return Widget(data: data, bytesRead: &bytesRead)
    case 320_412_644: return Button(data: data, bytesRead: &bytesRead)
    case 841_129_444: return TextField(data: data, bytesRead: &bytesRead)
    case 1_006_836_449: return Row(data: data, bytesRead: &bytesRead)
    case 1_855_640_887: return Center(data: data, bytesRead: &bytesRead)
    case 2_164_488_861: return ListView(data: data, bytesRead: &bytesRead)
    case 2_415_007_766: return Column(data: data, bytesRead: &bytesRead)
    case 3_373_588_321: return Slider(data: data, bytesRead: &bytesRead)
    case 3_495_336_243: return Text(data: data, bytesRead: &bytesRead)
    default: return nil
    }
  }

  init(tag: UInt32?) {
    self.tag = tag
  }

  required init?(data: Data) {
    var ptr = data.startIndex + 8

    var tag: UInt32?
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

    var tag: UInt32?
    if data.readSize(ofField: 0) < 0 {
      tag = nil
    } else {
      tag = data.read(at: ptr)
      ptr += 4
    }

    self.tag = tag

    bytesRead = ptr - data.startIndex
  }

  func write(to data: inout Data, offset: Int) -> Int {
    let dataCountBefore = data.count

    data.reserveCapacity(offset + 8)

    data.append(typeID: TypeID(Widget_typeID))
    data.append([0], count: 1 * 4)

    if let tag = self.tag {
      data.write(size: 4, ofField: 0, offset: offset)
      data.append(int: tag)
    } else {
      data.write(size: -1, ofField: 0, offset: offset)
    }

    return data.count - dataCountBefore
  }

  func data() -> Data? {
    var data = Data()
    _ = write(to: &data, offset: 0)
    return data
  }
}