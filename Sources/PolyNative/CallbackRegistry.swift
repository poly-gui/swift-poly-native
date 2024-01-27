//
//  CallbackRegistry.swift
//
//
//  Created by Kenneth Ng on 25/01/2024.
//

import Foundation

typealias CallbackHandle = Int32

class CallbackRegistry {
    private var callbacks: [Int32: Callback] = [:]

    func register(_ callback: Callback) {
        callbacks[callback.handle] = callback
    }
    
    func unregister(handle: CallbackHandle) {
        callbacks.removeValue(forKey: handle)
    }

    func isHandleRegistered(_ handle: Int32) -> Bool {
        return callbacks[handle] != nil
    }

    func callbackWithHandle(_ handle: Int32) -> Callback? {
        return callbacks[handle]
    }
}
