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
        if let array = JSON as? [NSDictionary] {
            return try array.map { try self.init(map: KeyedMapper(JSON: $0, type: self)) }
        } else {
            throw MapperError.rootTypeMismatchError(forType: self, value: JSON, expectedType: [NSDictionary].self)
        }
    }
}

public struct KeyedMapper<Object: Mappable> {
    public let JSON: NSDictionary
    
    public init(JSON: NSDictionary, type: Object.Type) {
        self.JSON = JSON
    }
    
    //MARK: RawRepresentable
    public func from<T: RawRepresentable>(_ field: Object.Key) throws -> T {
        let object = try self.JSONFromField(field)
        guard let rawValue = object as? T.RawValue else {
            throw MapperError.typeMismatchError(field: field, forType: Object.self, value: object, expectedType: T.RawValue.self)
        }
        
        guard let value = T(rawValue: rawValue) else {
            throw MapperError.invalidRawValueError(field: field, forType: Object.self, value: rawValue, expectedType: T.self)
        }
        
        return value
    }
    
    public func optionalFrom<T: RawRepresentable>(_ field: Object.Key) -> T? {
        return try? self.from(field)
    }
    
    public func optionalFrom<T: RawRepresentable>(_ fields: [Object.Key]) -> T? {
        for field in fields {
            if let value: T = try? self.from(field) {
                return value
            }
        }
        
        return nil
    }
    
    //MARK: Mappable
    public func from<T: Mappable>(_ field: Object.Key) throws -> T {
        let value = try self.JSONFromField(field)
        if let JSON = value as? NSDictionary {
            return try T(map: KeyedMapper<T>(JSON: JSON, type: T.self))
        }
        
        throw MapperError.typeMismatchError(field: field, forType: Object.self, value: value, expectedType: NSDictionary.self)
    }
    
    public func from<T: Mappable>(_ field: Object.Key) throws -> [T] {
        let value = try self.JSONFromField(field)
        if let JSON = value as? [NSDictionary] {
            return try JSON.map { try T(map: KeyedMapper<T>(JSON: $0, type: T.self)) }
        }
        
        throw MapperError.typeMismatchError(field: field, forType: Object.self, value: value, expectedType: [NSDictionary].self)
    }
    
    public func optionalFrom<T: Mappable>(_ field: Object.Key) -> T? {
        return try? self.from(field)
    }
    
    public func optionalFrom<T: Mappable>(_ field: Object.Key) -> [T]? {
        return try? self.from(field)
    }
    
    public func optionalFrom<T: Mappable>(_ fields: [Object.Key]) -> T? {
        for field in fields {
            if let value: T = try? self.from(field) {
                return value
            }
        }
        
        return nil
    }
    
    //MARK: Convertible
    public func from<T: Convertible>(_ field: Object.Key) throws -> T where T == T.ConvertedType {
        return try self.from(field: field, transformation: T.fromMap)
    }
    
    public func from<T: Convertible>(_ field: Object.Key) throws -> T? where T == T.ConvertedType {
        return try self.from(field: field, transformation: T.fromMap)
    }
    
    public func from<T: Convertible>(_ field: Object.Key) throws -> [T] where T == T.ConvertedType {
        let value = try self.JSONFromField(field)
        if let JSON = value as? [AnyObject] {
            return try JSON.map(T.fromMap)
        }
        
        throw MapperError.typeMismatchError(field: field, forType: Object.self, value: value, expectedType: [AnyObject].self)
    }
    
    public func optionalFrom<T: Convertible>(_ field: Object.Key) -> T? where T == T.ConvertedType {
        return try? self.from(field: field, transformation: T.fromMap)
    }
    
    public func optionalFrom<T: Convertible>(_ field: Object.Key) -> [T]? where T == T.ConvertedType {
        return try? self.from(field)
    }
    
    public func optionalFrom<T: Convertible>(_ fields: [Object.Key]) -> T? where T == T.ConvertedType {
        for field in fields {
            if let value: T = try? self.from(field) {
                return value
            }
        }
        
        return nil
    }
    
    //MARK: Transformations
    public func from<T>(field: Object.Key, transformation: (AnyObject?) throws -> T) rethrows -> T {
        return try transformation(try? self.JSONFromField(field))
    }
    
    public func optionalFrom<T>(_ field: Object.Key, transformation: (AnyObject?) throws -> T?) -> T? {
        return (try? transformation(try? self.JSONFromField(field))).flatMap { $0 }
    }
    
    //MARK: Retrieving JSON from a field
    public func JSONFromField(_ field: Object.Key) throws -> AnyObject {
        if let value = field.stringValue.isEmpty ? self.JSON : self.JSON.safeValueForKeyPath(field.stringValue) {
            return value as AnyObject
        }
        
        throw MapperError.missingFieldError(field: field, forType: Object.self)
    }
}
