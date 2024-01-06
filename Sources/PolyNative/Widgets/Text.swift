//
//  Text.swift
//
//
//  Created by Kenneth Ng on 05/01/2024.
//

import AppKit
import Foundation

@MainActor
func makeText(with message: Text, parent: NSView) -> NSTextField {
    let text = NSTextField(labelWithString: message.content)
    if let tag = message.tag {
        text.tag = Int(tag)
    }

    parent.addSubview(text)

    return text
}
