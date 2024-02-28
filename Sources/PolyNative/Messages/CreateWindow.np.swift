// AUTOMATICALLY GENERATED BY NANOPACK. DO NOT MODIFY BY HAND.

import Foundation
import NanoPack

let CreateWindow_typeID: TypeID = 3_533_765_426

class CreateWindow: NanoPackMessage {
  var typeID: TypeID { return 3_533_765_426 }

  let title: String
  let description: String
  let width: Int32
  let height: Int32
  let tag: String

  init(title: String, description: String, width: Int32, height: Int32, tag: String) {
    self.title = title
    self.description = description
    self.width = width
    self.height = height
    self.tag = tag
  }

  required init?(data: Data) {
    var ptr = data.startIndex + 24

    let titleSize = data.readSize(ofField: 0)
    guard let title = data.read(at: ptr, withLength: titleSize) else {
      return nil
    }
    ptr += titleSize

    let descriptionSize = data.readSize(ofField: 1)
    guard let description = data.read(at: ptr, withLength: descriptionSize) else {
      return nil
    }
    ptr += descriptionSize

    let width: Int32 = data.read(at: ptr)
    ptr += 4

    let height: Int32 = data.read(at: ptr)
    ptr += 4

    let tagSize = data.readSize(ofField: 4)
    guard let tag = data.read(at: ptr, withLength: tagSize) else {
      return nil
    }
    ptr += tagSize

    self.title = title
    self.description = description
    self.width = width
    self.height = height
    self.tag = tag
  }

  required init?(data: Data, bytesRead: inout Int) {
    var ptr = data.startIndex + 24

    let titleSize = data.readSize(ofField: 0)
    guard let title = data.read(at: ptr, withLength: titleSize) else {
      return nil
    }
    ptr += titleSize

    let descriptionSize = data.readSize(ofField: 1)
    guard let description = data.read(at: ptr, withLength: descriptionSize) else {
      return nil
    }
    ptr += descriptionSize

    let width: Int32 = data.read(at: ptr)
    ptr += 4

    let height: Int32 = data.read(at: ptr)
    ptr += 4

    let tagSize = data.readSize(ofField: 4)
    guard let tag = data.read(at: ptr, withLength: tagSize) else {
      return nil
    }
    ptr += tagSize

    self.title = title
    self.description = description
    self.width = width
    self.height = height
    self.tag = tag

    bytesRead = ptr - data.startIndex
  }

  func data() -> Data? {
    let offset = 0

    var data = Data()
    data.reserveCapacity(24)

    data.append(typeID: TypeID(CreateWindow_typeID))
    data.append([0], count: 5 * 4)

    data.write(size: title.lengthOfBytes(using: .utf8), ofField: 0, offset: offset)
    data.append(string: title)

    data.write(size: description.lengthOfBytes(using: .utf8), ofField: 1, offset: offset)
    data.append(string: description)

    data.write(size: 4, ofField: 2, offset: offset)
    data.append(int: width)

    data.write(size: 4, ofField: 3, offset: offset)
    data.append(int: height)

    data.write(size: tag.lengthOfBytes(using: .utf8), ofField: 4, offset: offset)
    data.append(string: tag)

    return data
  }

  func dataWithLengthPrefix() -> Data? {
    let offset = 4

    var data = Data()
    data.reserveCapacity(24 + 4)

    data.append(int: Int32(0))
    data.append(typeID: TypeID(CreateWindow_typeID))
    data.append([0], count: 5 * 4)

    data.write(size: title.lengthOfBytes(using: .utf8), ofField: 0, offset: offset)
    data.append(string: title)

    data.write(size: description.lengthOfBytes(using: .utf8), ofField: 1, offset: offset)
    data.append(string: description)

    data.write(size: 4, ofField: 2, offset: offset)
    data.append(int: width)

    data.write(size: 4, ofField: 3, offset: offset)
    data.append(int: height)

    data.write(size: tag.lengthOfBytes(using: .utf8), ofField: 4, offset: offset)
    data.append(string: tag)

    data.write(size: data.count, at: 0)

    return data
  }
}
