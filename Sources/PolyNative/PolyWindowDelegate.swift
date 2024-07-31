import AppKit
import Foundation

typealias WindowResizeListener = (_ size: NSSize) -> Void
typealias WindowResizeListenerHandle = Int

class PolyWindowDelegate: NSObject, NSWindowDelegate {
    private var listeners: [Int: WindowResizeListener] = [:]

    func addResizeListener(_ listener: @escaping WindowResizeListener) -> WindowResizeListenerHandle {
        var handle: Int
        repeat {
            handle = Int.random(in: 0 ..< Int.max)
        } while listeners[handle] != nil
        listeners[handle] = listener
        return handle
    }

    func removeResizeListener(withHandle handle: WindowResizeListenerHandle) {
        listeners.removeValue(forKey: handle)
    }

    func windowWillResize(_ sender: NSWindow, to frameSize: NSSize) -> NSSize {
        listeners.forEach { _, listener in
            listener(frameSize)
        }
        return frameSize
    }
}
