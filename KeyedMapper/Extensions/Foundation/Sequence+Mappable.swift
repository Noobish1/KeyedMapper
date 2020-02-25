import Foundation

extension Sequence where Self.Iterator.Element: Mappable {
    public static func fromMap(_ values: [NSDictionary]) throws -> [Self.Iterator.Element] {
        return try values.map(Self.Iterator.Element.from)
    }
}

extension Sequence where Self.Iterator.Element: Sequence, Self.Iterator.Element.Iterator.Element: Mappable {
    public static func fromMap(_ values: [[NSDictionary]]) throws -> [[Self.Iterator.Element.Iterator.Element]] {
        return try values.map([Self.Iterator.Element.Iterator.Element].fromMap)
    }
}
