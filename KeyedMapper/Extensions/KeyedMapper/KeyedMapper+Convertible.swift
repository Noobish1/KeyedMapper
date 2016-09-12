import Foundation

public extension KeyedMapper {
    public func from<T: Convertible>(_ field: Object.Key) throws -> T where T == T.ConvertedType {
        return try self.from(field, transformation: T.fromMap)
    }
    
    public func from<T: Convertible>(_ field: Object.Key) throws -> T? where T == T.ConvertedType {
        return try self.from(field, transformation: T.fromMap)
    }
    
    public func from<T: Convertible>(_ field: Object.Key) throws -> [T] where T == T.ConvertedType {
        let value = try self.JSONFromField(field)
        
        guard let JSON = value as? [AnyObject] else {
            throw MapperError.typeMismatchError(field: field, forType: Object.self, value: value, expectedType: [AnyObject].self)
        }
        
        return try JSON.map(T.fromMap)
    }
    
    public func optionalFrom<T: Convertible>(_ field: Object.Key) -> T? where T == T.ConvertedType {
        return try? self.from(field, transformation: T.fromMap)
    }
    
    public func optionalFrom<T: Convertible>(_ field: Object.Key) -> [T]? where T == T.ConvertedType {
        return try? self.from(field)
    }
}
