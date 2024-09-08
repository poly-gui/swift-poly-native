// AUTOMATICALLY GENERATED BY NANOPACK. DO NOT MODIFY BY HAND.

import Foundation
import NanoPack

func makeNanoPackMessage(from data: Data) -> NanoPackMessage? {
    let typeID = data.readTypeID()
    switch typeID {
    case 320412644: return Button(data: data)
    case 837166865: return ClickEvent(data: data)
    case 841129444: return TextField(data: data)
    case 1006836449: return Row(data: data)
    case 1030062961: return SliderValueChangedEvent(data: data)
    case 1100735111: return ListViewItem(data: data)
    case 1676374721: return Widget(data: data)
    case 1855640887: return Center(data: data)
    case 2077451345: return ListViewInsertOperation(data: data)
    case 2164488861: return ListView(data: data)
    case 2223513129: return ListViewDeleteOperation(data: data)
    case 2286117075: return TextFieldChangedEvent(data: data)
    case 2415007766: return Column(data: data)
    case 3373588321: return Slider(data: data)
    case 3495336243: return Text(data: data)
    case 3516816492: return ListViewOperation(data: data)
    case 3604546751: return ListViewBatchOperations(data: data)
    case 3635009167: return FontStyle(data: data)
    case 4128951807: return ListViewItemConfig(data: data)
    default: return nil
    }
}

func makeNanoPackMessage(from data: Data, bytesRead: inout Int) -> NanoPackMessage? {
    let typeID = data.readTypeID()
    switch typeID {
    case 320412644: return Button(data: data, bytesRead: &bytesRead)
    case 837166865: return ClickEvent(data: data, bytesRead: &bytesRead)
    case 841129444: return TextField(data: data, bytesRead: &bytesRead)
    case 1006836449: return Row(data: data, bytesRead: &bytesRead)
    case 1030062961: return SliderValueChangedEvent(data: data, bytesRead: &bytesRead)
    case 1100735111: return ListViewItem(data: data, bytesRead: &bytesRead)
    case 1676374721: return Widget(data: data, bytesRead: &bytesRead)
    case 1855640887: return Center(data: data, bytesRead: &bytesRead)
    case 2077451345: return ListViewInsertOperation(data: data, bytesRead: &bytesRead)
    case 2164488861: return ListView(data: data, bytesRead: &bytesRead)
    case 2223513129: return ListViewDeleteOperation(data: data, bytesRead: &bytesRead)
    case 2286117075: return TextFieldChangedEvent(data: data, bytesRead: &bytesRead)
    case 2415007766: return Column(data: data, bytesRead: &bytesRead)
    case 3373588321: return Slider(data: data, bytesRead: &bytesRead)
    case 3495336243: return Text(data: data, bytesRead: &bytesRead)
    case 3516816492: return ListViewOperation(data: data, bytesRead: &bytesRead)
    case 3604546751: return ListViewBatchOperations(data: data, bytesRead: &bytesRead)
    case 3635009167: return FontStyle(data: data, bytesRead: &bytesRead)
    case 4128951807: return ListViewItemConfig(data: data, bytesRead: &bytesRead)
    default: return nil
    }
}