import Foundation

public extension KeyedMapper {
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
}
