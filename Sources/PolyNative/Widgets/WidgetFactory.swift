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
func makeWidget(with message: Widget, context: ApplicationContext) -> NSView? {
    var view: NSView?

    switch message.typeID {
    case Text_typeID:
        view = makeText(with: message as! Text)
    case TextField_typeID:
        view = makeTextField(with: message as! TextField, context: context)
    case Center_typeID:
        view = makeCenter(with: message as! Center, context: context)
    case Row_typeID:
        view = makeRow(with: message as! Row, context: context)
    case Column_typeID:
        view = makeColumn(with: message as! Column, context: context)
    case Button_typeID:
        view = makeButton(with: message as! Button, context: context)
    case ListView_typeID:
        view = makeListView(with: message as! ListView, context: context)
    case Slider_typeID:
        view = makeSlider(with: message as! Slider, context: context)
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

@MainActor
func makeWidget<Parent: NSView>(with message: Widget, parent: Parent, context: ApplicationContext, commit: ViewCommiter<Parent> = defaultCommit(_:_:)) -> NSView? {
    var view: NSView?

    switch message.typeID {
    case Text_typeID:
        view = makeText(with: message as! Text, parent: parent, commit: commit)
    case TextField_typeID:
        view = makeTextField(with: message as! TextField, parent: parent, context: context, commit: commit)
    case Center_typeID:
        view = makeCenter(with: message as! Center, parent: parent, context: context, commit: commit)
    case Row_typeID:
        view = makeRow(with: message as! Row, parent: parent, context: context, commit: commit)
    case Column_typeID:
        view = makeColumn(with: message as! Column, parent: parent, context: context, commit: commit)
    case Button_typeID:
        view = makeButton(with: message as! Button, parent: parent, context: context, commit: commit)
    case ListView_typeID:
        view = makeListView(with: message as! ListView, parent: parent, context: context, commit: commit)
    case Slider_typeID:
        view = makeSlider(with: message as! Slider, parent: parent, context: context, commit: commit)

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
