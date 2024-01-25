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
func makeWidget<Parent: NSView>(with message: Widget, parent: Parent, context: ApplicationContext, commit: ViewCommiter<Parent> = defaultCommit(_:_:)) -> NSView? {
    var view: NSView?

    switch message.typeID {
    case Text_typeID:
        view = makeText(with: message as! Text, parent: parent, commit: commit)

    case Center_typeID:
        view = makeCenter(with: message as! Center, parent: parent, context: context, commit: commit)

    case Column_typeID:
        view = makeColumn(with: message as! Column, parent: parent, context: context, commit: commit)

    case Button_typeID:
        view = makeButton(with: message as! Button, parent: parent, context: context, commit: commit)

    default:
        return nil
    }

    guard let view else {
        return nil
    }

    if let tag = message.tag {
        context.viewRegistry.registry(view: view, with: tag)
    }

    return view
}
