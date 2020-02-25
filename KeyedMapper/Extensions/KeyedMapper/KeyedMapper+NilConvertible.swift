import Foundation

extension KeyedMapper {
    public func from<T: NilConvertible>(_ field: Object.Key) throws -> T where T == T.ConvertedType {
        return try T.fromMap(try? json.value(fromField: field.stringValue, forObject: Object.self))
    }
}
