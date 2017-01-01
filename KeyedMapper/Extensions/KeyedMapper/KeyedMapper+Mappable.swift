import Foundation

public extension KeyedMapper {
    public func from<T: Mappable>(_ field: Object.Key) throws -> T {
        return try T.from(dictionary: try json.value(fromField: field.stringValue, forObject: Object.self))
    }

    public func from<T: Mappable>(_ field: Object.Key) throws -> [T] {
        return try [T].fromMap(try json.value(fromField: field.stringValue, forObject: Object.self))
    }

    public func from<T: Mappable>(_ field: Object.Key) throws -> [[T]] {
        let value: [[NSDictionary]] = try json.value(fromField: field.stringValue, forObject: Object.self)

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
