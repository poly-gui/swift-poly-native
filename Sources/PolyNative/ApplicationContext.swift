//
//  ApplicationContext.swift
//
//
//  Created by Kenneth Ng on 24/01/2024.
//

import Foundation

class ApplicationContext {
    let callbackRegistry: CallbackRegistry
    let viewRegistry: ViewRegistry
    let portableLayer: PortableLayerServiceClient

    init(portableLayer: PortableLayerServiceClient) {
        self.callbackRegistry = CallbackRegistry()
        self.viewRegistry = ViewRegistry()
        self.portableLayer = portableLayer
    }
}
