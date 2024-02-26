//
//  ApplicationContext.swift
//
//
//  Created by Kenneth Ng on 24/01/2024.
//

import Foundation

class ApplicationContext {
    let messageChannel: MessageChannel
    let callbackRegistry: CallbackRegistry
    let viewRegistry: ViewRegistry
    let rpc: RPC

    init(messageChannel: MessageChannel) {
        self.messageChannel = messageChannel
        self.callbackRegistry = CallbackRegistry()
        self.viewRegistry = ViewRegistry()
        self.rpc = RPC(through: messageChannel)
    }
}
