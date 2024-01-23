//
//  Column.swift
//
//
//  Created by Kenneth Ng on 07/01/2024.
//

import AppKit
import Foundation

@MainActor
func makeColumn<Parent: NSView>(with message: Column, parent: Parent, commit: ViewCommiter<Parent>) -> NSStackView? {
    let stackView = NSStackView()

    stackView.orientation = .vertical
    
    switch message.horizontalAlignment {
    case .center:
        stackView.alignment = .centerX
    case .bottom:
        stackView.alignment = .bottom
    case .start:
        stackView.alignment = .leading
    case .end:
        stackView.alignment = .trailing
    default:
        break
    }
    
    let gravity: NSStackView.Gravity
    switch message.verticalAlignment {
    case .start:
        gravity = .top
    case .center:
        gravity = .center
    case .end:
        gravity = .bottom
    default:
        gravity = .center
    }
    
    for child in message.children {
        guard makeWidget(with: child, parent: stackView, commit: { child, parent in
            parent.addView(child, in: gravity)
        }) != nil else {
            return nil
        }
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
