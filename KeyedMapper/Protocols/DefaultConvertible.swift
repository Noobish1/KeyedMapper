import Foundation

public protocol DefaultConvertible: Convertible {}

extension DefaultConvertible {
    public static func fromMap(_ value: Any) throws -> ConvertedType {
        guard let object = value as? ConvertedType else {
            throw MapperError.convertible(value: value, expectedType: ConvertedType.self)
        }

        return object
    }
}

extension DefaultConvertible where ConvertedType: RawRepresentable {
    public static func fromMap(_ value: Any) throws -> ConvertedType {
        guard let rawValue = value as? ConvertedType.RawValue else {
            throw MapperError.convertible(value: value, expectedType: ConvertedType.RawValue.self)
        }

        guard let value = ConvertedType(rawValue: rawValue) else {
            throw MapperError.invalidRawValue(rawValue: rawValue, rawValueType: ConvertedType.self)
        }

        return value
    }
}

extension NSDictionary: DefaultConvertible {
    public typealias ConvertedType = NSDictionary
}
extension NSArray: DefaultConvertible {
    public typealias ConvertedType = NSArray
}

extension String: DefaultConvertible {}
extension Int: DefaultConvertible {}
extension UInt: DefaultConvertible {}
extension Float: DefaultConvertible {}
extension Double: DefaultConvertible {}
extension Bool: DefaultConvertible {}
