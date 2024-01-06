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
func makeWidget(with message: Widget, parent: NSView? = nil) -> NSView? {
    switch message.typeID {
    case Text_typeID:
        return makeText(with: message as! Text)

    case Center_typeID:
        return makeCenter(with: message as! Center, parent: parent)

    default:
        return nil
    }
}
