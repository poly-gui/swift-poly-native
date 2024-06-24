//
//  StandardIOMessageChannel.swift
//
//
//  Created by Kenneth Ng on 24/01/2024.
//

import Foundation
import NanoPack

class StandardIOChannel: Channel {
    private let stdin: Pipe
    private let stdout: Pipe
    private var isClosed = false

    var messages: AsyncStream<Data> {
        AsyncStream { continuation in
            Task {
                while true {
                    let byteCount = stdout.fileHandleForReading.readData(ofLength: 4).withUnsafeBytes {
                        $0.load(as: Int32.self).littleEndian
                    }
                    let messageData = stdout.fileHandleForReading.readData(ofLength: Int(byteCount))
                    continuation.yield(messageData)
                }
            }
        }
    }

    var packets: AsyncStream<ChannelPacket> {
        AsyncStream { continuation in
            Task {
                while !isClosed {
                    let delimiter = self.stdout.fileHandleForReading.readData(ofLength: 8)
                    if delimiter.count < 4 {
                        continue
                    }

                    let requestID = delimiter[0..<4].withUnsafeBytes {
                        $0.load(as: UInt32.self)
                    }
                    let messageSize = delimiter[4..<8].withUnsafeBytes {
                        $0.load(as: UInt32.self)
                    }

                    if messageSize == 0 {
                        continuation.yield(.ack(forRequestID: requestID))
                    } else {
                        let messageData = stdout.fileHandleForReading.readData(ofLength: Int(messageSize))
                        guard let message = makeNanoPackMessage(from: messageData) else {
                            continue
                        }
                        continuation.yield(.request(id: requestID, body: message))
                    }
                }
            }
        }
    }

    init(process: Process) {
        self.stdin = Pipe()
        self.stdout = Pipe()
        process.standardInput = stdin
        process.standardOutput = stdout
    }

    func send(packet: ChannelPacket) {
        switch packet {
        case .request(id: let requestID, body: let message):
            var data = Data(capacity: message.headerSize + 8)
            data.append(int: requestID)
            data.append(int: UInt32(0))
            let bodySize = message.write(to: &data, offset: 8)
            data.write(size: bodySize, at: 4)
            stdin.fileHandleForWriting.write(data)

        case .ack(forRequestID: let requestID):
            var data = Data(capacity: 8)
            data.append(int: requestID)
            data.append(int: UInt32(0))
            stdin.fileHandleForWriting.write(data)
        }
    }

    func close() {
        isClosed = true
    }
}
