//
//  Column.swift
//
//
//  Created by Kenneth Ng on 07/01/2024.
//

import AppKit
import Foundation

class PolyColumn: NSStackView {
    convenience init(_ message: Column) {
        self.init()

        orientation = .vertical

        switch message.horizontalAlignment {
        case .center:
            alignment = .centerX
        case .bottom:
            alignment = .bottom
        case .start:
            alignment = .leading
        case .end:
            alignment = .trailing
        default:
            break
        }
    }
}

@MainActor
func makeColumn(with message: Column, context: ApplicationContext) -> NSStackView? {
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
        guard let view = makeWidget(with: child, parent: stackView, context: context, commit: { child, parent in
            parent.addView(child, in: gravity)
        }) else {
            return nil
        }
    }

    return stackView
}

@MainActor
func makeColumn<Parent: NSView>(with message: Column, parent: Parent, context: ApplicationContext, commit: ViewCommiter<Parent>) -> NSStackView? {
    guard let stackView = makeColumn(with: message, context: context) else {
        return nil
    }

    commit(stackView, parent)

    stackView.translatesAutoresizingMaskIntoConstraints = false

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
