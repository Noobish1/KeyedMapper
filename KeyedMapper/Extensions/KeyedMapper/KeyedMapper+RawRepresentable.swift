import Foundation

public extension KeyedMapper {
    public func from<T: RawRepresentable>(_ field: Object.Key) throws -> T {
        let object = try JSON(fromField: field)
        
        guard let rawValue = object as? T.RawValue else {
            throw MapperError.typeMismatchError(field: field.stringValue, forType: Object.self, value: object, expectedType: T.RawValue.self)
        }
        
        guard let value = T(rawValue: rawValue) else {
            throw MapperError.invalidRawValueError(field: field.stringValue, forType: Object.self, value: rawValue, expectedType: T.self)
        }
        
        return value
    }
    
    public func optionalFrom<T: RawRepresentable>(_ field: Object.Key) -> T? {
        return try? from(field)
    }
}
