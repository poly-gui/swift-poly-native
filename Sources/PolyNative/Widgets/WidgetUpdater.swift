//
//  File.swift
//
//
//  Created by Kenneth Ng on 25/01/2024.
//

import AppKit
import Foundation

@MainActor
func updateWidget(old view: NSView, new widget: Widget, context: ApplicationContext) {
    switch widget.typeID {
    case Text_typeID:
        updateText(current: view as! NSTextField, new: widget as! Text)
    default:
        break
    }
}
