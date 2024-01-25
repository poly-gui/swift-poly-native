//
//  Button.swift
//
//
//  Created by Kenneth Ng on 24/01/2024.
//

import AppKit
import Foundation

@MainActor
func makeButton<Parent: NSView>(with message: Button, parent: Parent, context: ApplicationContext, commit: ViewCommiter<Parent>) -> NSButton {
    let callback = OnClickCallback(handle: message.onClick, context: context)

    let btn = NSButton(title: message.text, target: callback, action: #selector(OnClickCallback.call(_:)))

    context.callbackRegistry.register(callback)

    commit(btn, parent)

    return btn
}

class OnClickCallback: Callback {
    let handle: Int32

    private let context: ApplicationContext

    init(handle: Int32, context: ApplicationContext) {
        self.context = context
        self.handle = handle
    }

    @objc
    func call(_ sender: NSButton) {
        guard let event = NSApp.currentEvent else {
            return
        }

        let clickEvent = ClickEvent(timestamp: Int32(event.timestamp))
        guard let clickEventData = clickEvent.data() else {
            return
        }

        let invokeCallback = InvokeCallback(handle: handle, args: clickEventData)
        context.messageChannel.send(message: invokeCallback)
    }
}
