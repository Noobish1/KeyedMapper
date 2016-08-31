import Foundation

public protocol DefaultConvertible: Convertible {}

public extension DefaultConvertible {
    public static func fromMap(_ value: AnyObject?) throws -> ConvertedType {
        if let object = value as? ConvertedType {
            return object
        }

        throw ConvertibleError(value: value, type: ConvertedType.self)
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
