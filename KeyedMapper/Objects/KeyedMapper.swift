import Foundation

public protocol Mappable {
    associatedtype Key: JSONKey

    init(map: KeyedMapper<Self>) throws

    static func from(_ value: Any) throws -> Self
}

public extension Mappable {
    public static func from(_ value: Any) throws -> Self {
        return try self.init(map: KeyedMapper(JSON: value, type: self))
    }
}

public struct KeyedMapper<Object: Mappable> {
    internal let json: JSON

    public init(JSON value: Any, type: Object.Type) throws {
        self.json = try JSON(value: value, forObject: type)
    }

    // MARK: Transformations
    public func from<T>(_ field: Object.Key, transformation: (Any) throws -> T) throws -> T {
        let value: Any = try json.value(fromField: field.stringValue, forObject: Object.self)

        return try transformation(value)
    }

    public func optionalFrom<T>(_ field: Object.Key, transformation: (Any) throws -> T) rethrows -> T? {
        return try (try? json.value(fromField: field.stringValue, forObject: Object.self)).map(transformation)
    }
}
