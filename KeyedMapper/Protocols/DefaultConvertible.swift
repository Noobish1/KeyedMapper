import Foundation

public protocol DefaultConvertible: Convertible {}

public extension DefaultConvertible {
    public static func fromMap(_ value: Any) throws -> ConvertedType {
        guard let object = value as? ConvertedType else {
            throw MapperError.convertibleError(value: value, expectedType: ConvertedType.self)
        }

        return object
    }
}

public extension DefaultConvertible where ConvertedType: RawRepresentable {
    public static func fromMap(_ value: Any) throws -> ConvertedType {
        guard let rawValue = value as? ConvertedType.RawValue else {
            throw MapperError.convertibleError(value: value, expectedType: ConvertedType.RawValue.self)
        }

        guard let value = ConvertedType(rawValue: rawValue) else {
            throw MapperError.customError(field: nil, message: "\"\(rawValue)\" is not a valid rawValue of \(type(of: self))")
        }

        return value
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
