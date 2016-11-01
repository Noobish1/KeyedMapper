import Foundation
import KeyedMapper

public struct Recording {
    enum Status: String {
        case None = "0"
        case Recorded = "-3"
        case Recording = "-2"
        case Unknown
    }

    enum RecGroup: String {
        case Deleted = "Deleted"
        case Default = "Default"
        case LiveTV = "LiveTV"
        case Unknown
    }

    let startTsStr: String
    let status: Status
    let recordId: String
    let recGroup: RecGroup
}

extension Recording: Mappable {
    public enum Key: String, JSONKey {
        case StartTs
        case RecordId
        case Status
        case RecGroup
    }

    public init(map: KeyedMapper<Recording>) throws {
        startTsStr = try map.from(.StartTs)
        recordId = try map.from(.RecordId)
        status = map.optionalFrom(.Status) ?? .Unknown
        recGroup = map.optionalFrom(.RecGroup) ?? .Unknown
    }
}
