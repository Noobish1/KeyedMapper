import Foundation

public protocol DefaultConvertible: Convertible {}

public extension DefaultConvertible {
    public static func fromMap(_ value: Any?) throws -> ConvertedType {
        guard let object = value as? ConvertedType else {
            throw ConvertibleError(value: value, type: ConvertedType.self)
        }

        return object
    }
}

extension NSDictionary: DefaultConvertible {}
extension NSArray: DefaultConvertible {}

extension String: DefaultConvertible {}
extension Int: DefaultConvertible {}
extension UInt: DefaultConvertible {}
extension Float: DefaultConvertible {}
extension Double: DefaultConvertible {}
extension Bool: DefaultConvertible {}
