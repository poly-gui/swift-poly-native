//
//  File.swift
//
//
//  Created by Kenneth Ng on 24/01/2024.
//

import Foundation
import NanoPack

typealias MessageHandler = (_ data: Data) -> Void

protocol MessageChannel {
    var messages: AsyncStream<Data> { get }

    func send(message: NanoPackMessage)
}
