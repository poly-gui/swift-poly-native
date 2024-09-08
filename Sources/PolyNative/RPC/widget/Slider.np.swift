// AUTOMATICALLY GENERATED BY NANOPACK. DO NOT MODIFY BY HAND.

import Foundation
import NanoPack

let Slider_typeID: TypeID = 3_373_588_321

class Slider: Widget {
  override var typeID: TypeID { return 3_373_588_321 }

  override var headerSize: Int { return 28 }

  let value: Double
  let minValue: Double
  let maxValue: Double
  let onValueChanged: UInt32
  let width: Double

  init(
    tag: UInt32?, value: Double, minValue: Double, maxValue: Double, onValueChanged: UInt32,
    width: Double
  ) {
    self.value = value
    self.minValue = minValue
    self.maxValue = maxValue
    self.onValueChanged = onValueChanged
    self.width = width
    super.init(tag: tag)
  }

  required init?(data: Data) {
    var ptr = data.startIndex + 28

    var tag: UInt32?
    if data.readSize(ofField: 0) < 0 {
      tag = nil
    } else {
      tag = data.read(at: ptr)
      ptr += 4
    }

    let value: Double = data.read(at: ptr)
    ptr += 8

    let minValue: Double = data.read(at: ptr)
    ptr += 8

    let maxValue: Double = data.read(at: ptr)
    ptr += 8

    let onValueChanged: UInt32 = data.read(at: ptr)
    ptr += 4

    let width: Double = data.read(at: ptr)
    ptr += 8

    self.value = value
    self.minValue = minValue
    self.maxValue = maxValue
    self.onValueChanged = onValueChanged
    self.width = width
    super.init(tag: tag)
  }

  required init?(data: Data, bytesRead: inout Int) {
    var ptr = data.startIndex + 28

    var tag: UInt32?
    if data.readSize(ofField: 0) < 0 {
      tag = nil
    } else {
      tag = data.read(at: ptr)
      ptr += 4
    }

    let value: Double = data.read(at: ptr)
    ptr += 8

    let minValue: Double = data.read(at: ptr)
    ptr += 8

    let maxValue: Double = data.read(at: ptr)
    ptr += 8

    let onValueChanged: UInt32 = data.read(at: ptr)
    ptr += 4

    let width: Double = data.read(at: ptr)
    ptr += 8

    self.value = value
    self.minValue = minValue
    self.maxValue = maxValue
    self.onValueChanged = onValueChanged
    self.width = width
    super.init(tag: tag)

    bytesRead = ptr - data.startIndex
  }

  override func write(to data: inout Data, offset: Int) -> Int {
    let dataCountBefore = data.count

    data.reserveCapacity(offset + 28)

    data.append(typeID: TypeID(Slider_typeID))
    data.append([0], count: 6 * 4)

    if let tag = self.tag {
      data.write(size: 4, ofField: 0, offset: offset)
      data.append(int: tag)
    } else {
      data.write(size: -1, ofField: 0, offset: offset)
    }

    data.write(size: 8, ofField: 1, offset: offset)
    data.append(double: value)

    data.write(size: 8, ofField: 2, offset: offset)
    data.append(double: minValue)

    data.write(size: 8, ofField: 3, offset: offset)
    data.append(double: maxValue)

    data.write(size: 4, ofField: 4, offset: offset)
    data.append(int: onValueChanged)

    data.write(size: 8, ofField: 5, offset: offset)
    data.append(double: width)

    return data.count - dataCountBefore
  }

  override func data() -> Data? {
    var data = Data()
    _ = write(to: &data, offset: 0)
    return data
  }
}