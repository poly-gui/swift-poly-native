import Foundation
import NanoPack

func makeNanoPackMessage(from data: Data, typeID: TypeID) -> NanoPackMessage? {
  switch typeID {
  case 100: return Widget(data: data)
  case 103: return Column(data: data)
  case 102: return Center(data: data)
  case 2: return InvokeCallback(data: data)
  case 20: return CreateWidget(data: data)
  case 101: return Text(data: data)
  case 10: return CreateWindow(data: data)
  default: return nil
  }
}
