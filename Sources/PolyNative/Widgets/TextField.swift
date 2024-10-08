//
//  File.swift
//
//
//  Created by Kenneth Ng on 13/02/2024.
//

import AppKit
import Foundation

class PolyTextFieldCell: NSTextFieldCell, Paddable {
    var padding: Double = 0
    var paddingTop: Double = 0
    var paddingLeft: Double = 0
    var paddingBottom: Double = 0
    var paddingRight: Double = 0
    var paddingX: Double = 0
    var paddingY: Double = 0

    override func drawingRect(forBounds rect: NSRect) -> NSRect {
        return NSMakeRect(rect.origin.x + paddingX, rect.origin.y + paddingY, rect.width + paddingX * 2, rect.height + paddingY * 2)
    }
}

class PolyTextField: NSTextField, NSTextFieldDelegate {
    private var context: ApplicationContext?

    private var valueChanged: ValueChangedCallback?
    var valueChangedHandle: CallbackHandle? {
        didSet {
            guard let context, oldValue != valueChangedHandle else {
                return
            }

            if let oldValue {
                context.callbackRegistry.unregister(handle: oldValue)
                if let valueChangedHandle {
                    let valueChanged = ValueChangedCallback(handle: valueChangedHandle, context: context)
                    context.callbackRegistry.register(valueChanged)
                }
            } else {
                let valueChanged = ValueChangedCallback(handle: valueChangedHandle!, context: context)
                context.callbackRegistry.register(valueChanged)
            }
        }
    }

    convenience init(message: TextField, context: ApplicationContext) {
        let valueChanged = ValueChangedCallback(handle: message.onValueChanged, context: context)
        context.callbackRegistry.register(valueChanged)

        self.init(string: "")
        self.placeholderString = message.placeholder
        self.context = context
        self.valueChanged = valueChanged
        self.valueChangedHandle = message.onValueChanged
        self.delegate = self
    }

    func controlTextDidChange(_ obj: Notification) {
        guard let textField = obj.object as? NSTextField, textField == self,
              let valueChanged
        else {
            return
        }
        valueChanged.call(newValue: textField.stringValue)
    }
}

class ValueChangedCallback: Callback {
    let handle: CallbackHandle

    private let context: ApplicationContext

    init(handle: CallbackHandle, context: ApplicationContext) {
        self.handle = handle
        self.context = context
    }

    func call(newValue: String) {
        let onValueChanged = TextFieldChangedEvent(newValue: newValue)
        context.portableLayer.invokeCallback(handle, onValueChanged) { _ in }
    }
}

@MainActor
func makeTextField(with message: TextField, context: ApplicationContext) -> NSTextField {
    return PolyTextField(message: message, context: context)
}

@MainActor
func makeTextField<Parent: NSView>(with message: TextField, parent: Parent, context: ApplicationContext, commit: ViewCommiter<Parent>) -> NSTextField {
    let textField = PolyTextField(message: message, context: context)
    commit(textField, parent)
    return textField
}

@MainActor
func updateTextField(current textField: PolyTextField, new config: TextField) {
    textField.placeholderString = config.placeholder
    textField.stringValue = config.value
    textField.valueChangedHandle = config.onValueChanged
}
