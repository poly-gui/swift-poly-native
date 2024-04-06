//
//  Text.swift
//
//
//  Created by Kenneth Ng on 05/01/2024.
//

import AppKit
import Foundation

@MainActor
func makeText(with message: Text) -> NSTextField {
    let textField = NSTextField(labelWithString: message.content)

    let font: NSFont?
    if message.style.fontFamily == "" {
        font = .systemFont(
            ofSize: CGFloat(message.style.fontSize),
            weight: .fromNumber(message.style.fontWeight))
    } else {
        font = NSFont(name: message.style.fontFamily, size: CGFloat(message.style.fontSize))
    }

    if font != nil {
        textField.font = font
    }

    return textField
}

@MainActor
func makeText<Parent: NSView>(with message: Text, parent: Parent, commit: ViewCommiter<Parent>) -> NSTextField {
    let text = makeText(with: message)
    commit(text, parent)
    return text
}

@MainActor
func updateText(current text: NSTextField, new config: Text) {
    text.stringValue = config.content
    text.sizeToFit()

    let font: NSFont?
    if config.style.fontFamily == "" {
        font = .systemFont(
            ofSize: CGFloat(config.style.fontSize),
            weight: .fromNumber(config.style.fontWeight))
    } else {
        font = NSFont(name: config.style.fontFamily, size: CGFloat(config.style.fontSize))
    }

    if font != nil {
        text.font = font
    }
}
