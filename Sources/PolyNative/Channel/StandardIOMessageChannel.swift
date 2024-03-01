//
//  StandardIOMessageChannel.swift
//
//
//  Created by Kenneth Ng on 24/01/2024.
//

import Foundation
import NanoPack

class StandardIOMessageChannel: MessageChannel {
    private let stdin: Pipe
    private let stdout: Pipe

    var messages: AsyncStream<Data> {
        AsyncStream { continuation in
            Task {
                while (true) {
                    let byteCount = stdout.fileHandleForReading.readData(ofLength: 4).withUnsafeBytes {
                        $0.load(as: Int32.self).littleEndian
                    }
                    let messageData = stdout.fileHandleForReading.readData(ofLength: Int(byteCount))
                    continuation.yield(messageData)
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

    func send(message: NanoPackMessage) {
        if let data = message.dataWithLengthPrefix() {
            stdin.fileHandleForWriting.write(data)
        }
    }
}
