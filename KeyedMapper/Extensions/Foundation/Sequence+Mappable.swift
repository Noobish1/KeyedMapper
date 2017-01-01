import Foundation

public extension Sequence where Self.Iterator.Element: Mappable {
    public static func fromMap(_ values: [NSDictionary]) throws -> [Self.Iterator.Element] {
        return try values.map(Self.Iterator.Element.from)
    }
}

public extension Sequence where Self.Iterator.Element: Sequence,
                                Self.Iterator.Element.Iterator.Element: Mappable {
    private typealias ResultingType = Self.Iterator.Element.Iterator.Element

    public static func fromMap(_ values: [[NSDictionary]]) throws -> [[ResultingType]] {
        return try values.map([ResultingType].fromMap)
    }
}
