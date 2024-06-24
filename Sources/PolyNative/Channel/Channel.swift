//
//  File.swift
//
//
//  Created by Kenneth Ng on 24/01/2024.
//

import Foundation
import NanoPack

typealias MessageDataHandler = (_ data: Data) -> Void

protocol Channel {
    var packets: AsyncStream<ChannelPacket> { get }

    func send(packet: ChannelPacket)

    func close()
}
