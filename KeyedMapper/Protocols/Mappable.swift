import Foundation

public protocol Mappable {
    associatedtype Key: JSONKey

    init(map: KeyedMapper<Self>) throws

    static func from(_ dictionary: NSDictionary) throws -> Self
}

extension Mappable {
    public static func from(_ dictionary: NSDictionary) throws -> Self {
        return try self.init(map: KeyedMapper(JSON: dictionary, type: self))
    }
}
