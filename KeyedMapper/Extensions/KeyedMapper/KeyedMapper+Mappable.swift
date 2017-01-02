import Foundation

public extension KeyedMapper {
    public func from<T: Mappable>(_ field: Object.Key) throws -> T {
        return try from(field, transformation: T.from)
    }

    public func from<T: Mappable>(_ field: Object.Key) throws -> [T] {
        return try from(field, transformation: [T].from)
    }

    public func from<T: Mappable>(_ field: Object.Key) throws -> [[T]] {
        return try from(field, transformation: [[T]].from)
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
