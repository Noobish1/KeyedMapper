import Foundation

public struct KeyedMapper<Object: Mappable> {
    internal let json: JSON

    public init(JSON dictionary: NSDictionary, type: Object.Type) {
        self.json = JSON(dictionary: dictionary)
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
