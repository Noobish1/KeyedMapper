import Foundation

public extension KeyedMapper {
    public func from<T: Convertible>(_ field: Object.Key) throws -> T where T == T.ConvertedType {
        return try from(field, transformation: T.fromMap)
    }

    // This function is necessary because swift does not coerce the from that returns T to an optional
    public func from<T: Convertible>(_ field: Object.Key) throws -> T? where T == T.ConvertedType {
        return try self.from(field, transformation: T.fromMap)
    }

    public func from<T: Convertible>(_ field: Object.Key) throws -> [T] where T == T.ConvertedType {
        let value = try JSON(fromField: field)

        guard let JSON = value as? [Any] else {
            throw MapperError.typeMismatchError(field: field.stringValue, forType: Object.self, value: value, expectedType: [Any].self)
        }

        return try JSON.map(T.fromMap)
    }

    public func optionalFrom<T: Convertible>(_ field: Object.Key) -> T? where T == T.ConvertedType {
        return try? from(field)
    }

    public func optionalFrom<T: Convertible>(_ field: Object.Key) -> [T]? where T == T.ConvertedType {
        return try? from(field)
    }
}
