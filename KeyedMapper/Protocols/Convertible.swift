import Foundation

public protocol Convertible {
    associatedtype ConvertedType = Self

    static func fromMap(_ value: Any) throws -> ConvertedType
}
