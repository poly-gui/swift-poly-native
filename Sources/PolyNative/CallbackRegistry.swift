//
//  CallbackRegistry.swift
//
//
//  Created by Kenneth Ng on 25/01/2024.
//

import Foundation

typealias CallbackHandle = UInt32

class CallbackRegistry {
    private var callbacks: [CallbackHandle: Callback] = [:]

    func register(_ callback: Callback) {
        callbacks[callback.handle] = callback
    }
    
    func unregister(handle: CallbackHandle) {
        callbacks.removeValue(forKey: handle)
    }

    func isHandleRegistered(_ handle: CallbackHandle) -> Bool {
        return callbacks[handle] != nil
    }

    func callbackWithHandle(_ handle: CallbackHandle) -> Callback? {
        return callbacks[handle]
    }
}
