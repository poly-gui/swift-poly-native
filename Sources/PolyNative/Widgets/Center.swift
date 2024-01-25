//
// Center.swift
//
//
//  Created by Kenneth Ng on 06/01/2024.
//

import AppKit
import Foundation

@MainActor
func makeCenter<Parent: NSView>(with message: Center, parent: Parent, context: ApplicationContext, commit: ViewCommiter<Parent>) -> NSView? {
    guard let child = makeWidget(with: message.child, parent: parent, context: context, commit: commit) else {
        return nil
    }
    
    child.translatesAutoresizingMaskIntoConstraints = false
    child.centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true
    child.centerYAnchor.constraint(equalTo: parent.centerYAnchor).isActive = true

    return child
}
