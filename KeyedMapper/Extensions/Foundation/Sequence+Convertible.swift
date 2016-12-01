import Foundation

public extension Sequence where Self.Iterator.Element: Convertible {
    public static func fromMap(_ values: [Any]) throws -> [Self.Iterator.Element.ConvertedType] {
        return try values.map(Self.Iterator.Element.fromMap)
    }
}
