// AUTOMATICALLY GENERATED BY NANOPACK. DO NOT MODIFY BY HAND.

import Foundation
import NanoPack

func makeNanoPackMessage(from data: Data, typeID: TypeID) -> NanoPackMessage? {
    switch typeID {
    case 4: return UpdateWidgets(data: data)
    case 104: return Button(data: data)
    case 101: return Text(data: data)
    case 3: return UpdateWidget(data: data)
    case 10: return CreateWindow(data: data)
    case 1041: return ClickEvent(data: data)
    case 2: return InvokeCallback(data: data)
    case 100: return Widget(data: data)
    case 102: return Center(data: data)
    case 103: return Column(data: data)
    case 20: return CreateWidget(data: data)
    default: return nil
    }
}
