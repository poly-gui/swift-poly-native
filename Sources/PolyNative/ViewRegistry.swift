//
//  ViewRegistry.swift
//
//
//  Created by Kenneth Ng on 25/01/2024.
//

import AppKit
import Foundation

typealias ViewTag = Int32

class ViewRegistry {
    private var views: [ViewTag: NSView] = [:]

    func registry(view: NSView, with tag: ViewTag) {
        views[tag] = view
    }

    func forget(viewWithTag: ViewTag) {
        views.removeValue(forKey: viewWithTag)
    }

    func viewWithTag(_ tag: ViewTag) -> NSView? {
        return views[tag]
    }
}
