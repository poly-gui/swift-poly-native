import Foundation
import NanoPack

func makeNanoPackMessage(from data: Data, typeID: TypeID) -> NanoPackMessage? {
  switch typeID {
  case 2: return InvokeCallback(data: data)
  case 10: return CreateWindow(data: data)
  default: return nil
  }
}
