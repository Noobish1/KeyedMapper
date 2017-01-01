import Foundation

public extension KeyedMapper {
    public func from<T: Mappable>(_ field: Object.Key) throws -> T {
        return try T.from(dictionary: try JSONValue(fromField: field))
    }

    public func from<T: Mappable>(_ field: Object.Key) throws -> [T] {
        return try [T].fromMap(try JSONValue(fromField: field))
    }

    public func from<T: Mappable>(_ field: Object.Key) throws -> [[T]] {
        let value: [[NSDictionary]] = try JSONValue(fromField: field)

        return try value.map { try [T].fromMap($0) }
    }

    public func optionalFrom<T: Mappable>(_ field: Object.Key) -> T? {
        return try? from(field)
    }

    public func optionalFrom<T: Mappable>(_ field: Object.Key) -> [T]? {
        return try? from(field)
    }

    public func optionalFrom<T: Mappable>(_ field: Object.Key) -> [[T]]? {
        return try? from(field)
    }
}
