//
//  ApplicationContext.swift
//
//
//  Created by Kenneth Ng on 24/01/2024.
//

import Foundation

class ApplicationContext {
    let messageChannel: MessageChannel
    var callbackRegistry: CallbackRegistry
    var viewRegistry: ViewRegistry

    init(messageChannel: MessageChannel) {
        self.messageChannel = messageChannel
        self.callbackRegistry = CallbackRegistry()
        self.viewRegistry = ViewRegistry()
    }
}
