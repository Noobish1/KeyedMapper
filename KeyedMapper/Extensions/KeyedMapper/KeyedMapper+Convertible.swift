import Foundation

public extension KeyedMapper {
    public func from<T: Convertible>(_ field: Object.Key) throws -> T where T == T.ConvertedType {
        return try from(field, transformation: T.fromMap)
    }

    public func from<T: Convertible>(_ field: Object.Key) throws -> [T] where T == T.ConvertedType {
        let value = try JSON(fromField: field)

        guard let JSON = value as? [Any] else {
            throw MapperError.typeMismatch(field: field.stringValue, forType: Object.self, value: value, expectedType: [Any].self)
        }

        return try [T].fromMap(JSON)
    }

    public func from<T: Convertible>(_ field: Object.Key) throws -> [[T]] where T == T.ConvertedType {
        let value = try JSON(fromField: field)

        guard let JSON = value as? [[Any]] else {
            throw MapperError.typeMismatch(field: field.stringValue, forType: Object.self, value: value, expectedType: [[Any]].self)
        }

        return try JSON.map { try [T].fromMap($0) }
    }

    public func from<U: Convertible, T: Convertible>(_ field: Object.Key) throws -> [U: [T]] where U == U.ConvertedType, T == T.ConvertedType {
        let object = try JSON(fromField: field)

        guard let data = object as? NSDictionary else {
            throw MapperError.typeMismatch(field: field.stringValue, forType: Object.self, value: object, expectedType: NSDictionary.self)
        }

        var result = [U: [T]]()
        for (key, value) in data {
            guard let array = value as? [Any] else {
                throw MapperError.typeMismatch(field: field.stringValue, forType: Object.self, value: object, expectedType: [Any].self)
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
