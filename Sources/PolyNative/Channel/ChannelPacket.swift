import Foundation
import NanoPack

enum ChannelPacket {
    case request(id: UInt32, body: NanoPackMessage)
    case ack(forRequestID: UInt32)
}
