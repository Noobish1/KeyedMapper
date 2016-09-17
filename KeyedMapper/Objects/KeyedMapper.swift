import Foundation

public protocol Mappable {
    associatedtype Key: JSONKey
    
    init(map: KeyedMapper<Self>) throws
    
    static func from(JSON: NSDictionary) throws -> Self
    static func from(JSON: NSArray) throws -> [Self]
}

public extension Mappable {
    public static func from(JSON: NSDictionary) throws -> Self {
        return try self.init(map: KeyedMapper(JSON: JSON, type: self))
    }
    
    public static func from(JSON: NSArray) throws -> [Self] {
        guard let array = JSON as? [NSDictionary] else {
            throw MapperError.rootTypeMismatchError(forType: self, value: JSON, expectedType: [NSDictionary].self)
        }
        
        return try array.map { try self.init(map: KeyedMapper(JSON: $0, type: self)) }
    }
}

public struct KeyedMapper<Object: Mappable> {
    public let JSON: NSDictionary
    
    public init(JSON: NSDictionary, type: Object.Type) {
        self.JSON = JSON
    }
    
    //MARK: Transformations
    public func from<T>(_ field: Object.Key, transformation: (Any) throws -> T) throws -> T {
        return try transformation(try self.JSONFromField(field))
    }
    
    public func optionalFrom<T>(_ field: Object.Key, transformation: (Any) throws -> T) rethrows -> T? {
        return try (try? self.JSONFromField(field)).map(transformation)
    }
    
    //MARK: Retrieving JSON from a field
    public func JSONFromField(_ field: Object.Key) throws -> Any {
        guard let value = field.stringValue.isEmpty ? self.JSON : self.JSON.safeValueForKeyPath(field.stringValue) else {
            throw MapperError.missingFieldError(field: field.stringValue, forType: Object.self)
        }
        
        return value
    }
}
