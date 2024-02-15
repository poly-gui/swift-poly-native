// AUTOMATICALLY GENERATED BY NANOPACK. DO NOT MODIFY BY HAND.

import Foundation
import NanoPack

let UpdateWidget_typeID: TypeID = 3

class UpdateWidget: NanoPackMessage {
  var typeID: TypeID { return 3 }

  let tag: Int32
  let widget: Widget

  init(tag: Int32, widget: Widget) {
    self.tag = tag
    self.widget = widget
  }

  required init?(data: Data) {
    var ptr = data.startIndex + 12

    let tag: Int32 = data.read(at: ptr)
    ptr += 4

    let widgetByteSize = data.readSize(ofField: 1)
    guard let widget = Widget.from(data: data[ptr...]) else {
      return nil
    }
    ptr += widgetByteSize

    self.tag = tag
    self.widget = widget
  }

  required init?(data: Data, bytesRead: inout Int) {
    var ptr = data.startIndex + 12

    let tag: Int32 = data.read(at: ptr)
    ptr += 4

    let widgetByteSize = data.readSize(ofField: 1)
    guard let widget = Widget.from(data: data[ptr...]) else {
      return nil
    }
    ptr += widgetByteSize

    self.tag = tag
    self.widget = widget

    bytesRead = ptr - data.startIndex
  }

  func data() -> Data? {
    let offset = 0

    var data = Data()
    data.reserveCapacity(12)

    data.append(int: Int32(UpdateWidget_typeID))
    data.append([0], count: 2 * 4)

    data.write(size: 4, ofField: 0, offset: offset)
    data.append(int: tag)

    guard let widgetData = widget.data() else {
      return nil
    }
    data.write(size: widgetData.count, ofField: 1, offset: offset)
    data.append(widgetData)

    return data
  }

  func dataWithLengthPrefix() -> Data? {
    let offset = 4

    var data = Data()
    data.reserveCapacity(12 + 4)

    data.append(int: Int32(0))
    data.append(int: Int32(UpdateWidget_typeID))
    data.append([0], count: 2 * 4)

    data.write(size: 4, ofField: 0, offset: offset)
    data.append(int: tag)

    guard let widgetData = widget.data() else {
      return nil
    }
    data.write(size: widgetData.count, ofField: 1, offset: offset)
    data.append(widgetData)

    data.write(size: data.count, at: 0)

    return data
  }
}
