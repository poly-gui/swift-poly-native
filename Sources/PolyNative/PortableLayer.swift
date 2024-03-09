//
//  File.swift
//
//
//  Created by Kenneth Ng on 06/03/2024.
//

import Foundation
import NanoPack

typealias MessageHandler = (_ message: NanoPackMessage) async -> Void

class PortableLayer {
    private var pendingRequests = [UInt32: CheckedContinuation<Void, Never>]()
    private var pendingCallbacks = [Int32: (Data) -> Void]()

    fileprivate var channel: Channel?
    private var messageHandler: MessageHandler

    fileprivate init(messageHandler: @escaping MessageHandler) {
        self.messageHandler = messageHandler
    }

    fileprivate func start() throws {}

    func invoke(_ callback: CallbackHandle, args: NanoPackMessage) {
        guard let channel = channel,
              let argsData = args.data()
        else {
            return
        }
        let invokeCallback = InvokeCallback(handle: callback, args: argsData, replyTo: nil)
        channel.send(packet: .request(id: generateRequestID(), body: invokeCallback))
    }

    func invoke(_ callback: CallbackHandle, args: NanoPackMessage, onResult: @escaping (Data) -> Void) {
        guard let channel = channel,
              let argData = args.data()
        else {
            return
        }
        let requestID = generateRequestID()
        let replyHandle = generateReplyHandle()
        pendingCallbacks[replyHandle] = onResult
        let invokeCallback = InvokeCallback(handle: callback, args: argData, replyTo: replyHandle)
        channel.send(packet: .request(id: requestID, body: invokeCallback))
    }

    fileprivate func onIncomingPacket(_ packet: ChannelPacket) async {
        guard let channel = channel else {
            return
        }

        switch packet {
        case .ack(forRequestID: let requestID):
            requestAcked(requestID)

        case .request(id: let requestID, body: let message):
            if message.typeID == ReplyFromCallback_typeID {
                replyFromCallbackReceived(message as! ReplyFromCallback)
            } else {
                await messageHandler(message)
                channel.send(packet: .ack(forRequestID: requestID))
            }
        }
    }

    private func requestAcked(_ requestID: UInt32) {
        guard let continuation = pendingRequests[requestID] else {
            return
        }
        pendingRequests.removeValue(forKey: requestID)
        continuation.resume()
    }

    private func replyFromCallbackReceived(_ msg: ReplyFromCallback) {
        guard let cb = pendingCallbacks[msg.to] else {
            return
        }
        pendingCallbacks.removeValue(forKey: msg.to)
        cb(msg.args)
    }

    private func generateRequestID() -> UInt32 {
        var id: UInt32
        repeat {
            id = UInt32.random(in: 1 ... UInt32.max)
        } while pendingRequests[id] != nil
        return id
    }

    private func generateReplyHandle() -> Int32 {
        var id: Int32
        repeat {
            id = Int32.random(in: 0 ... Int32.max)
        } while pendingCallbacks[id] != nil
        return id
    }
}

class PortableLayerInChildProcess: PortableLayer {
    private var process: Process?

    override init(messageHandler: @escaping MessageHandler) {
        super.init(messageHandler: messageHandler)
    }

    override func start() throws {
        guard let portableBinaryPath = Bundle.main.path(forResource: "bundle", ofType: nil) else {
            return
        }

        let portableLayerProcess = Process()
        portableLayerProcess.executableURL = NSURL.fileURL(withPath: portableBinaryPath)

        let channel = StandardIOChannel(process: portableLayerProcess)
        Task {
            for await packet in channel.packets {
                Task { await onIncomingPacket(packet) }
            }
        }

        self.channel = channel

        try portableLayerProcess.run()
    }
}
