import Foundation

public protocol NilConvertible {
    associatedtype ConvertedType = Self

    static func from(_ value: Any?) throws -> ConvertedType
}
