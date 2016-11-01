import Foundation
import KeyedMapper

public struct ProgramList {
    public let programs: [Program]
}

extension ProgramList: Mappable {
    public enum Key: String, JSONKey {
        case Programs = "ProgramList.Programs"
    }

    public init(map: KeyedMapper<ProgramList>) throws {
        try programs = map.from(.Programs)
    }
}
