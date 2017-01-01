import Foundation

public extension Sequence where Self.Iterator.Element: Convertible, Self.Iterator.Element.ConvertedType == Self.Iterator.Element {
    public static func from(_ values: [Any]) throws -> [Self.Iterator.Element.ConvertedType] {
        return try values.map(Self.Iterator.Element.from)
    }
}

public extension Sequence where Self.Iterator.Element: Sequence,
                                Self.Iterator.Element.Iterator.Element: Convertible,
                                Self.Iterator.Element.Iterator.Element.ConvertedType == Self.Iterator.Element.Iterator.Element {
    private typealias ResultingType = Self.Iterator.Element.Iterator.Element.ConvertedType

    public static func from(_ values: [[Any]]) throws -> [[ResultingType]] {
        return try values.map([ResultingType].from)
    }
}
