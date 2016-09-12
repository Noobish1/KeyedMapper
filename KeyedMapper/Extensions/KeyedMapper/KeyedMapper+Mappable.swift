import Foundation

public extension KeyedMapper {
    public func from<T: Mappable>(_ field: Object.Key) throws -> T {
        let value = try self.JSONFromField(field)
        
        guard let JSON = value as? NSDictionary else {
            throw MapperError.typeMismatchError(field: field, forType: Object.self, value: value, expectedType: NSDictionary.self)
        }
        
        return try T(map: KeyedMapper<T>(JSON: JSON, type: T.self))
    }
    
    public func from<T: Mappable>(_ field: Object.Key) throws -> [T] {
        let value = try self.JSONFromField(field)
        
        guard let JSON = value as? [NSDictionary] else {
            throw MapperError.typeMismatchError(field: field, forType: Object.self, value: value, expectedType: [NSDictionary].self)
        }
        
        return try JSON.map { try T(map: KeyedMapper<T>(JSON: $0, type: T.self)) }
    }
    
    public func optionalFrom<T: Mappable>(_ field: Object.Key) -> T? {
        return try? self.from(field)
    }
    
    public func optionalFrom<T: Mappable>(_ field: Object.Key) -> [T]? {
        return try? self.from(field)
    }
}
