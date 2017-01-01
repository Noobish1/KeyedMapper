import Foundation

public protocol Mappable {
    associatedtype Key: JSONKey

    init(map: KeyedMapper<Self>) throws

    static func from(dictionary: NSDictionary) throws -> Self
    static func from(array: [Any]) throws -> [Self]
}

public extension Mappable {
    public static func from(dictionary: NSDictionary) throws -> Self {
        return try self.init(map: KeyedMapper(JSON: dictionary, type: self))
    }

    public static func from(array: [Any]) throws -> [Self] {
        guard let dictArray = array as? [NSDictionary] else {
            throw MapperError.rootTypeMismatch(forType: self, value: array, expectedType: [NSDictionary].self)
        }

        return try dictArray.map(from)
    }
}

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
