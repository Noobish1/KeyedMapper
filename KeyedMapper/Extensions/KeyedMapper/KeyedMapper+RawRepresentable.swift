import Foundation

public extension KeyedMapper {
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
}
