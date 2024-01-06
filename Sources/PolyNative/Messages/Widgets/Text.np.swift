// AUTOMATICALLY GENERATED BY NANOPACK. DO NOT MODIFY BY HAND.

import Foundation
import NanoPack

let Text_typeID: TypeID = 101

class Text: Widget {
  override var typeID: TypeID { return 101 }

  let content: String

  init(tag: Int32?, content: String) {
    self.content = content
    super.init(tag: tag)
  }

  required init?(data: Data) {
    var ptr = data.startIndex + 12

    let tag: Int32?
    if data.readSize(ofField: 0) < 0 {
      tag = nil
    } else {
      tag = data.read(at: ptr)
      ptr += 4
    }

    let contentSize = data.readSize(ofField: 1)
    guard let content = data.read(at: ptr, withLength: contentSize) else {
      return nil
    }
    ptr += contentSize

    self.content = content
    super.init(tag: tag)
  }

  override func data() -> Data? {
    var data = Data()
    data.reserveCapacity(12)

    withUnsafeBytes(of: Int32(Text_typeID)) {
      data.append(contentsOf: $0)
    }

    data.append([0], count: 8)

    if let tag = self.tag {
      data.write(size: 4, ofField: 0)
      data.append(int: tag)
    } else {
      data.write(size: -1, ofField: 0)
    }

    data.write(size: content.lengthOfBytes(using: .utf8), ofField: 1)
    data.append(string: content)

    return data
  }
}