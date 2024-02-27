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
    return NSTextField(labelWithString: message.content)
}

@MainActor
func makeText<Parent: NSView>(with message: Text, parent: Parent, commit: ViewCommiter<Parent>) -> NSTextField {
    let text = NSTextField(labelWithString: message.content)
    commit(text, parent)
    return text
}

@MainActor
func updateText(current text: NSTextField, new config: Text) {
    text.stringValue = config.content
    text.sizeToFit()
}
