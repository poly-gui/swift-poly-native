//
// Center.swift
//
//
//  Created by Kenneth Ng on 06/01/2024.
//

import AppKit
import Foundation

@MainActor
func makeCenter(with message: Center, parent: NSView?) -> NSView? {
    guard let parent = parent,
          let child = makeWidget(with: message.child, parent: parent)
    else {
        return nil
    }

    child.centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true
    child.centerYAnchor.constraint(equalTo: parent.centerYAnchor).isActive = true

    return child
}
