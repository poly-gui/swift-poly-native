//
//  WidgetFactory.swift
//
//
//  Created by Kenneth Ng on 05/01/2024.
//

import AppKit
import Foundation
import NanoPack

@MainActor
func makeWidget(with message: CreateWidget) -> NSView? {
    switch message.widget.typeID {
    case Text_typeID:
        return makeText(with: message.widget as! Text)

    default:
        return nil
    }
}
