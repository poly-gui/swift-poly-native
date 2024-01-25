//
//  CallbackRegistry.swift
//
//
//  Created by Kenneth Ng on 25/01/2024.
//

import Foundation

class CallbackRegistry {
    private var callbacks: [Int32: Callback] = [:]

    func register(_ callback: Callback) {
        callbacks[callback.handle] = callback
    }
}
