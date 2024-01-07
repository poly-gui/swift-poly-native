//
//  Text.swift
//
//
//  Created by Kenneth Ng on 05/01/2024.
//

import AppKit
import Foundation

@MainActor
func makeText<Parent: NSView>(with message: Text, parent: Parent, commit: ViewCommiter<Parent>) -> NSTextField {
    let text = NSTextField(labelWithString: message.content)
    if let tag = message.tag {
        text.tag = Int(tag)
    }

    commit(text, parent)

    return text
}
