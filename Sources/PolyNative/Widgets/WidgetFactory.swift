//
//  WidgetFactory.swift
//
//
//  Created by Kenneth Ng on 05/01/2024.
//

import AppKit
import Foundation
import NanoPack

typealias ViewCommiter<Parent: NSView> = (_ child: NSView, _ parent: Parent) -> Void

func defaultCommit<Parent: NSView>(_ child: NSView, _ parent: Parent) -> Void {
    parent.addSubview(child)
}

@MainActor
func makeWidget<Parent: NSView>(with message: Widget, parent: Parent, commit: ViewCommiter<Parent> = defaultCommit(_:_:)) -> NSView? {
    switch message.typeID {
    case Text_typeID:
        return makeText(with: message as! Text, parent: parent, commit: commit)

    case Center_typeID:
        return makeCenter(with: message as! Center, parent: parent, commit: commit)
        
    case Column_typeID:
        return makeColumn(with: message as! Column, parent: parent, commit: commit)

    default:
        return nil
    }
}
