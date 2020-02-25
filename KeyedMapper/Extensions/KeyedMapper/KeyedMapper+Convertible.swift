import Foundation

extension KeyedMapper {
    public func from<T: Convertible>(_ field: Object.Key) throws -> T where T == T.ConvertedType {
        return try from(field, transformation: T.fromMap)
    }

    public func from<T: Convertible>(_ field: Object.Key) throws -> [T] where T == T.ConvertedType {
        return try [T].fromMap(try json.value(fromField: field.stringValue, forObject: Object.self))
    }

    public func from<T: Convertible>(_ field: Object.Key) throws -> [[T]] where T == T.ConvertedType {
        return try [[T]].fromMap(try json.value(fromField: field.stringValue, forObject: Object.self))
    }

    public func from<U: Convertible, T: Convertible>(_ field: Object.Key) throws -> [U: [T]] where U == U.ConvertedType, T == T.ConvertedType {
        let data: NSDictionary = try json.value(fromField: field.stringValue, forObject: Object.self)

        var result = [U: [T]]()
        for (key, value) in data {
            guard let array = value as? [Any] else {
                throw MapperError.typeMismatch(field: field.stringValue, forType: Object.self, value: value, expectedType: [Any].self)
            }

            result[try U.fromMap(key)] = try [T].fromMap(array)
        }

        return result
    }

    public func optionalFrom<T: Convertible>(_ field: Object.Key) -> T? where T == T.ConvertedType {
        return try? from(field)
    }

    public func optionalFrom<T: Convertible>(_ field: Object.Key) -> [T]? where T == T.ConvertedType {
        return try? from(field)
    }

    public func optionalFrom<T: Convertible>(_ field: Object.Key) -> [[T]]? where T == T.ConvertedType {
        return try? from(field)
    }

    public func optionalFrom<U: Convertible, T: Convertible>(_ field: Object.Key) -> [U: [T]]? where U == U.ConvertedType, T == T.ConvertedType {
        return try? from(field)
    }
}
