// AUTOMATICALLY GENERATED BY NANOPACK. DO NOT MODIFY BY HAND.

import Foundation
import NanoPack

let FontStyle_typeID: TypeID = 3_635_009_167

class FontStyle: NanoPackMessage {
  var typeID: TypeID { return 3_635_009_167 }

  var headerSize: Int { return 16 }

  let fontFamily: String
  let fontWeight: UInt32
  let fontSize: UInt32

  init(fontFamily: String, fontWeight: UInt32, fontSize: UInt32) {
    self.fontFamily = fontFamily
    self.fontWeight = fontWeight
    self.fontSize = fontSize
  }

  required init?(data: Data) {
    var ptr = data.startIndex + 16

    let fontFamilySize = data.readSize(ofField: 0)
    guard let fontFamily = data.read(at: ptr, withLength: fontFamilySize) else {
      return nil
    }
    ptr += fontFamilySize

    let fontWeight: UInt32 = data.read(at: ptr)
    ptr += 4

    let fontSize: UInt32 = data.read(at: ptr)
    ptr += 4

    self.fontFamily = fontFamily
    self.fontWeight = fontWeight
    self.fontSize = fontSize
  }

  required init?(data: Data, bytesRead: inout Int) {
    var ptr = data.startIndex + 16

    let fontFamilySize = data.readSize(ofField: 0)
    guard let fontFamily = data.read(at: ptr, withLength: fontFamilySize) else {
      return nil
    }
    ptr += fontFamilySize

    let fontWeight: UInt32 = data.read(at: ptr)
    ptr += 4

    let fontSize: UInt32 = data.read(at: ptr)
    ptr += 4

    self.fontFamily = fontFamily
    self.fontWeight = fontWeight
    self.fontSize = fontSize

    bytesRead = ptr - data.startIndex
  }

  func write(to data: inout Data, offset: Int) -> Int {
    let dataCountBefore = data.count

    data.reserveCapacity(offset + 16)

    data.append(typeID: TypeID(FontStyle_typeID))
    data.append([0], count: 3 * 4)

    data.write(size: fontFamily.lengthOfBytes(using: .utf8), ofField: 0, offset: offset)
    data.append(string: fontFamily)

    data.write(size: 4, ofField: 1, offset: offset)
    data.append(int: fontWeight)

    data.write(size: 4, ofField: 2, offset: offset)
    data.append(int: fontSize)

    return data.count - dataCountBefore
  }

  func data() -> Data? {
    var data = Data()
    _ = write(to: &data, offset: 0)
    return data
  }
}
