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
        if let JSON = value as? [AnyObject] {
            return try JSON.map(T.fromMap)
        }
        
        throw MapperError.typeMismatchError(field: field, forType: Object.self, value: value, expectedType: [AnyObject].self)
    }
    
    public func optionalFrom<T: Convertible>(_ field: Object.Key) -> T? where T == T.ConvertedType {
        return try? self.from(field, transformation: T.fromMap)
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
}
