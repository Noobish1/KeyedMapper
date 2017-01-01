import Foundation

public protocol Convertible {
    associatedtype ConvertedType = Self

    static func from(_ value: Any) throws -> ConvertedType
}
