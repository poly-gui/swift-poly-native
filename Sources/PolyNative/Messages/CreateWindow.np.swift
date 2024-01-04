// AUTOMATICALLY GENERATED BY NANOPACK. DO NOT MODIFY BY HAND.

import Foundation
import NanoPack

let CreateWindow_typeID: TypeID = 10

class CreateWindow: NanoPackMessage {
  let typeID: TypeID = 10

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

  func data() -> Data? {
    var data = Data()
    data.reserveCapacity(24)

    withUnsafeBytes(of: Int32(CreateWindow_typeID)) {
      data.append(contentsOf: $0)
    }

    data.append([0], count: 20)

    data.write(size: title.lengthOfBytes(using: .utf8), ofField: 0)
    data.append(string: title)

    data.write(size: description.lengthOfBytes(using: .utf8), ofField: 1)
    data.append(string: description)

    data.write(size: 4, ofField: 2)
    data.append(int: width)

    data.write(size: 4, ofField: 3)
    data.append(int: height)

    data.write(size: tag.lengthOfBytes(using: .utf8), ofField: 4)
    data.append(string: tag)

    return data
  }
}
