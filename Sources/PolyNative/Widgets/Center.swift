//
// Center.swift
//
//
//  Created by Kenneth Ng on 06/01/2024.
//

import AppKit
import Foundation

@MainActor
func makeCenter(with message: Center, parent: NSView) -> NSView? {
    let containerView = NSView()
    parent.addSubview(parent)

    containerView.topAnchor.constraint(equalTo: parent.topAnchor).isActive = true
    containerView.bottomAnchor.constraint(equalTo: parent.bottomAnchor).isActive = true
    containerView.leftAnchor.constraint(equalTo: parent.leftAnchor).isActive = true
    containerView.rightAnchor.constraint(equalTo: parent.rightAnchor).isActive = true

    guard let child = makeWidget(with: message.child, parent: containerView) else {
        return nil
    }

    child.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
    child.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true

    return containerView
}
