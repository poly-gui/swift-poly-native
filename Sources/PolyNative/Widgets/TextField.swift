//
//  File.swift
//  
//
//  Created by Kenneth Ng on 13/02/2024.
//

import AppKit
import Foundation

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
              let valueChanged else {
            return
        }
        valueChanged.call(newValue: textField.stringValue)
    }
}

class ValueChangedCallback: Callback {
    let handle: Int32
    
    private let context: ApplicationContext
    
    init(handle: Int32, context: ApplicationContext) {
        self.handle = handle
        self.context = context
    }
    
    func call(newValue: String) {
        let onValueChanged = OnValueChanged(newValue: newValue)
        guard let argData = onValueChanged.data() else {
            return
        }
        context.messageChannel.send(message: InvokeCallback(handle: handle, args: argData, replyTo: nil))
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
