import Foundation

public protocol Mappable {
    associatedtype Key: JSONKey

    init(map: KeyedMapper<Self>) throws

    static func from(JSON: [AnyHashable : Any]) throws -> Self
    static func from(JSON: [Any]) throws -> [Self]
}

public extension Mappable {
    public static func from(JSON: [AnyHashable : Any]) throws -> Self {
        return try self.init(map: KeyedMapper(JSON: JSON, type: self))
    }

    public static func from(JSON: [Any]) throws -> [Self] {
        guard let array = JSON as? [[AnyHashable : Any]] else {
            throw MapperError.rootTypeMismatchError(forType: self, value: JSON, expectedType: [[AnyHashable : Any]].self)
        }

        return try array.map { try self.init(map: KeyedMapper(JSON: $0, type: self)) }
    }
}

public struct KeyedMapper<Object: Mappable> {
    public let JSON: [AnyHashable : Any]

    public init(JSON: [AnyHashable : Any], type: Object.Type) {
        self.JSON = JSON
    }

    //MARK: Transformations
    public func from<T>(_ field: Object.Key, transformation: (Any) throws -> T) throws -> T {
        return try transformation(try JSON(fromField: field))
    }

    public func optionalFrom<T>(_ field: Object.Key, transformation: (Any) throws -> T) rethrows -> T? {
        return try (try? JSON(fromField: field)).map(transformation)
    }

    //MARK: Retrieving JSON from a field
    internal func JSON(fromField field: Object.Key) throws -> Any {
        guard let value = field.stringValue.isEmpty ? JSON : safeValue(forKeyPath: field.stringValue, inDictionary: JSON) else {
            throw MapperError.missingFieldError(field: field.stringValue, forType: Object.self)
        }

        return value
    }

    internal func safeValue(forKeyPath keyPath: String, inDictionary dictionary: [AnyHashable : Any]) -> Any? {
        var object: Any? = dictionary
        var keys = keyPath.characters.split(separator: ".").map(String.init)

        while keys.count > 0, let currentObject = object {
            let key = keys.remove(at: 0)
            object = (currentObject as? [AnyHashable : Any])?[key]
        }

        return object
    }
}
