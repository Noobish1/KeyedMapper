import Foundation

public extension KeyedMapper {
    public func from<T: Mappable>(_ field: Object.Key) throws -> T {
        let value = try JSON(fromField: field)

        guard let JSON = value as? NSDictionary else {
            throw MapperError.typeMismatch(field: field.stringValue, forType: Object.self, value: value, expectedType: NSDictionary.self)
        }

        return try T.from(dictionary: JSON)
    }

    public func from<T: Mappable>(_ field: Object.Key) throws -> [T] {
        let value = try JSON(fromField: field)

        guard let JSON = value as? [NSDictionary] else {
            throw MapperError.typeMismatch(field: field.stringValue, forType: Object.self, value: value, expectedType: [NSDictionary].self)
        }

        return try [T].fromMap(JSON)
    }

    public func from<T: Mappable>(_ field: Object.Key) throws -> [[T]] {
        let value = try JSON(fromField: field)

        guard let JSON = value as? [[NSDictionary]] else {
            throw MapperError.typeMismatch(field: field.stringValue, forType: Object.self, value: value, expectedType: [[NSDictionary]].self)
        }

        return try JSON.map { try [T].fromMap($0) }
    }

    public func optionalFrom<T: Mappable>(_ field: Object.Key) -> T? {
        return try? from(field)
    }

    public func optionalFrom<T: Mappable>(_ field: Object.Key) -> [T]? {
        return try? from(field)
    }

    public func optionalFrom<T: Mappable>(_ field: Object.Key) -> [[T]]? {
        return try? from(field)
    }
}
