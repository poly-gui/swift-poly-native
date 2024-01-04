//
//  WindowManager.swift
//
//
//  Created by Kenneth Ng on 04/01/2024.
//

import AppKit
import Foundation

struct WindowManager {
    private var windows: [String: NSWindow] = [:]

    mutating func add(window: NSWindow, withTag: String) {
        windows[withTag] = window
    }

    func findWindow(withTag: String) -> NSWindow? {
        return windows[withTag]
    }
    
    mutating func closeWindow(withTag: String) {
        guard let window = windows.removeValue(forKey: withTag) else {
            return
        }
        window.close()
    }
}
