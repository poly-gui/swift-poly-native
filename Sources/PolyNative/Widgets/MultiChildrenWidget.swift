import Foundation
import AppKit

protocol MultiChildrenWidget: AnyObject where Self: NSView {
    func addView(_ view: NSView)

    func insertView(_ view: NSView, at index: Int)

    func insertView(_ view: NSView, before anotherView: NSView)
}
