import AppKit
import NanoPack
import Foundation

@MainActor
func updateWidget(old view: NSView, new widget: Widget, context: ApplicationContext, args: NanoPackMessage? = nil) {
    switch widget.typeID {
    case Text_typeID:
        updateText(current: view as! NSTextField, new: widget as! Text)
    case Button_typeID:
        updateButton(current: view as! PolyButton, new: widget as! Button, context: context)
    case Center_typeID:
        updateWidget(old: view, new: (widget as! Center).child, context: context)
    case ListView_typeID:
        guard let operations = args as? ListViewBatchOperations else {
            return
        }
        updateListView(current: view as! PolyListView, new: widget as! ListView, operations: operations)
    default:
        break
    }
}
