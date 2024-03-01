//
//  RPC.swift
//
//
//  Created by Kenneth Ng on 24/02/2024.
//

import Foundation
import NanoPack

class RPC {
    private var pendingReplies: [Int32: (Data) -> Void] = [:]
    private let channel: MessageChannel

    init(through channel: MessageChannel) {
        self.channel = channel
    }

    func reply(to replyHandle: Int32, data: Data) {
        guard let cb = pendingReplies.removeValue(forKey: replyHandle) else {
            return
        }
        cb(data)
    }

    func invoke(callback: CallbackHandle, args: NanoPackMessage) {
        guard let argData = args.data() else {
            return
        }
        channel.send(message: InvokeCallback(handle: callback, args: argData, replyTo: nil))
    }

    func invoke(_ callback: CallbackHandle, args: NanoPackMessage, onResult: @escaping (Data) -> Void) {
        guard let argData = args.data() else {
            return
        }
        let replyHandle = generateReplyHandle()
        pendingReplies[replyHandle] = onResult
        channel.send(message: InvokeCallback(handle: callback, args: argData, replyTo: replyHandle))
    }

    private func generateReplyHandle() -> Int32 {
        var id: Int32
        repeat {
            id = Int32.random(in: 0 ... Int32.max)
        } while pendingReplies[id] != nil
        return id
    }
}
