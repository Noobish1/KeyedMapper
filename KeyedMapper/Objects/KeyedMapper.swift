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

        return try dictArray.map { try self.init(map: KeyedMapper(JSON: $0, type: self)) }
    }
}

public struct KeyedMapper<Object: Mappable> {
    public let JSON: NSDictionary

    public init(JSON: NSDictionary, type: Object.Type) {
        self.JSON = JSON
    }

    // MARK: Transformations
    public func from<T>(_ field: Object.Key, transformation: (Any) throws -> T) throws -> T {
        return try transformation(try JSON(fromField: field))
    }

    public func optionalFrom<T>(_ field: Object.Key, transformation: (Any) throws -> T) rethrows -> T? {
        return try (try? JSON(fromField: field)).map(transformation)
    }

    // MARK: Retrieving JSON from a field
    internal func JSON(fromField field: Object.Key) throws -> Any {
        guard let value = field.stringValue.isEmpty ? JSON : safeValue(forField: field, in: JSON) else {
            throw MapperError.missingField(field: field.stringValue, forType: Object.self)
        }

        return value
    }

    internal func safeValue(forField field: Object.Key, in dictionary: NSDictionary) -> Any? {
        var object: Any? = dictionary
        var keys = field.stringValue.characters.split(separator: ".").map(String.init)

        while !keys.isEmpty, let currentObject = object {
            let key = keys.removeFirst()
            object = (currentObject as? NSDictionary)?[key]
        }

        return object
    }
}
