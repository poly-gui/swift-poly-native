//
//  File.swift
//
//
//  Created by Kenneth Ng on 22/02/2024.
//

import AppKit
import Foundation

@MainActor
func makeRow(with message: Row, context: ApplicationContext) -> NSStackView? {
    let stackView = NSStackView()
    stackView.orientation = .horizontal
    
    let gravity: NSStackView.Gravity
    switch message.horizontalAlignment {
    case .start:
        gravity = .leading
    case .end:
        gravity = .trailing
    case .center:
        gravity = .center
    default:
        gravity = .center
    }
    
    switch message.verticalAlignment {
    case .center:
        stackView.alignment = .centerY
    case .bottom:
        stackView.alignment = .bottom
    case .start:
        stackView.alignment = .top
    case .end:
        stackView.alignment = .bottom
    default:
        break
    }
    
    for child in message.children {
        guard makeWidget(with: child, parent: stackView, context: context, commit: { child, parent in
            parent.addView(child, in: gravity)
        }) != nil else {
            return nil
        }
    }
    
    return stackView
}

@MainActor
func makeRow<Parent: NSView>(with message: Row, parent: Parent, context: ApplicationContext, commit: ViewCommiter<Parent>) -> NSStackView? {
    guard let stackView = makeRow(with: message, context: context) else {
        return nil
    }
    
    commit(stackView, parent)
    
    if message.width != minContent {
        if message.width == fillParent {
            stackView.widthAnchor.constraint(equalTo: parent.widthAnchor).isActive = true
        } else {
            stackView.widthAnchor.constraint(equalToConstant: message.width).isActive = true
        }
    }
    if message.height != minContent {
        if message.height == fillParent {
            stackView.heightAnchor.constraint(equalTo: parent.heightAnchor).isActive = true
        } else {
            stackView.heightAnchor.constraint(equalToConstant: message.height).isActive = true
        }
    }
    
    return stackView
}
