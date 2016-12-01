import Foundation

public extension Sequence where Self.Iterator.Element: Mappable {
    public static func fromMap(_ values: [NSDictionary]) throws -> [Self.Iterator.Element] {
        return try values.map(Self.Iterator.Element.from)
    }
}
