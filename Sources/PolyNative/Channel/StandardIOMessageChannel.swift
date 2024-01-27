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
            stdout.fileHandleForReading.readabilityHandler = { pipe in
                let data = pipe.availableData
                guard !data.isEmpty else {
                    return
                }
                continuation.yield(data)
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
        if let data = message.data() {
            stdin.fileHandleForWriting.write(data)
        }
    }
}
