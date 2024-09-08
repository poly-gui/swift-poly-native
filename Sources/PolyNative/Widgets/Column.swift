//
//  Column.swift
//
//
//  Created by Kenneth Ng on 07/01/2024.
//

import AppKit
import Foundation

class PolyColumn: NSStackView, MultiChildrenWidget {
    private(set) var gravity: NSStackView.Gravity = .center

    static func committer(_ child: NSView, _ parent: PolyColumn) {
        parent.addView(child)
    }

    convenience init(_ message: Column) {
        self.init()
        orientation = .vertical

        gravity = switch message.verticalAlignment {
        case .start: .top
        case .center: .center
        case .end: .bottom
        default: .center
        }

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

    func addView(_ view: NSView) {
        addView(view, in: gravity)
    }

    func insertView(_ view: NSView, at index: Int) {
        insertView(view, at: index, in: gravity)
    }

    func insertView(_ view: NSView, before anotherView: NSView) {
        for i in 0 ..< arrangedSubviews.count {
            if anotherView == arrangedSubviews[i] {
                insertView(view, at: i, in: gravity)
                return
            }
        }
    }
}

@MainActor
func makeColumn(with message: Column, context: ApplicationContext) -> NSStackView? {
    let column = PolyColumn(message)
    for child in message.children {
        guard makeWidget(with: child, parent: column, context: context, commit: PolyColumn.committer(_:_:)) != nil else {
            return nil
        }
    }
    return column
}

@MainActor
func makeColumn<Parent: NSView>(with message: Column, parent: Parent, context: ApplicationContext, commit: ViewCommiter<Parent>) -> NSStackView? {
    guard let column = makeColumn(with: message, context: context) else {
        return nil
    }

    commit(column, parent)

    column.translatesAutoresizingMaskIntoConstraints = false

    if message.width != minContent {
        if message.width == fillParent {
            column.widthAnchor.constraint(equalTo: parent.widthAnchor).isActive = true
        } else {
            column.widthAnchor.constraint(equalToConstant: message.width).isActive = true
        }
    }
    if message.height != minContent {
        if message.height == fillParent {
            column.heightAnchor.constraint(equalTo: parent.heightAnchor).isActive = true
        } else {
            column.heightAnchor.constraint(equalToConstant: message.height).isActive = true
        }
    }

    return column
}
