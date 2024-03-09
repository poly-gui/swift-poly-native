//
//  Button.swift
//
//
//  Created by Kenneth Ng on 24/01/2024.
//

import AppKit
import Foundation

class PolyButton: NSButton {
    private(set) var onClickCallbackHandle: CallbackHandle?

    convenience init(message: Button, context: ApplicationContext) {
        let callback = OnClickCallback(handle: message.onClick, context: context)
        context.callbackRegistry.register(callback)
        self.init(title: message.text, target: callback, action: #selector(OnClickCallback.call(_:)))
        self.onClickCallbackHandle = message.onClick
    }

    func registerOnClickHandle(_ handle: CallbackHandle, context: ApplicationContext) {
        let callback = OnClickCallback(handle: handle, context: context)
        context.callbackRegistry.register(callback)
        self.target = callback
        self.action = #selector(OnClickCallback.call(_:))
        self.onClickCallbackHandle = handle
    }
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
        self.context.portableLayer.invoke(self.handle, args: clickEvent)
    }
}

@MainActor
func makeButton(with message: Button, context: ApplicationContext) -> NSButton {
    return PolyButton(message: message, context: context)
}

@MainActor
func makeButton<Parent: NSView>(with message: Button, parent: Parent, context: ApplicationContext, commit: ViewCommiter<Parent>) -> NSButton {
    let btn = PolyButton(message: message, context: context)
    commit(btn, parent)
    return btn
}

@MainActor
func updateButton(current btn: PolyButton, new config: Button, context: ApplicationContext) {
    btn.title = config.text
    if btn.onClickCallbackHandle == nil || btn.onClickCallbackHandle != config.onClick {
        btn.registerOnClickHandle(config.onClick, context: context)
    }
}
