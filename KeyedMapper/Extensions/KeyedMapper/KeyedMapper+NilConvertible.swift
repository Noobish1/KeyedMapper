import Foundation

public extension KeyedMapper {
    public func from<T: NilConvertible>(_ field: Object.Key) throws -> T where T == T.ConvertedType {
        return try T.fromMap(try? self.JSON(fromField: field))
    }
}
