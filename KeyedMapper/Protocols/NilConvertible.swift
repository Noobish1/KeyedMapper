import Foundation

public protocol NilConvertible {
    associatedtype ConvertedType = Self

    static func fromMap(_ value: Any?) throws -> ConvertedType
}
