import Foundation

public extension Sequence where Self.Iterator.Element: Convertible {
    public static func fromMap(_ value: Any) throws -> [Self.Iterator.Element.ConvertedType] {
        guard let values = value as? [Any] else {
            throw MapperError.convertible(value: value, expectedType: [Any].self)
        }

        return try values.map(Self.Iterator.Element.fromMap)
    }
}
