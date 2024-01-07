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

    for child in message.children {
        guard makeWidget(with: child, parent: stackView, commit: { child, parent in
            parent.addView(child, in: .bottom)
        }) != nil else {
            return nil
        }
    }

    commit(stackView, parent)

    return stackView
}
