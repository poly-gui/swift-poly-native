//
//  ViewRegistry.swift
//
//
//  Created by Kenneth Ng on 25/01/2024.
//

import AppKit
import Foundation

class ViewRegistry {
    private var views: [Int32: NSView] = [:]

    func registry(view: NSView, with tag: Int32) {
        views[tag] = view
    }

    func forget(viewWithTag: Int32) {
        views.removeValue(forKey: viewWithTag)
    }

    func viewWithTag(_ tag: Int32) -> NSView? {
        return views[tag]
    }
}
