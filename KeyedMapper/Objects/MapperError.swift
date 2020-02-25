import Foundation

public enum MapperError: Error {
    case custom(field: String?, message: String)
    case invalidRawValue(rawValue: Any, rawValueType: Any.Type)
    case missingField(field: String, forType: Any.Type)
    case typeMismatch(field: String, forType: Any.Type, value: Any, expectedType: Any.Type)
    case convertible(value: Any, expectedType: Any.Type)

    public var failureReason: String {
        switch self {
            case .custom(_, message: let message):
                return message
            case .invalidRawValue(rawValue: let rawValue, rawValueType: let rawValueType):
                return "\"\(rawValue)\" is not a valid rawValue of \(rawValueType)"
            case .missingField(field: let field, forType: let type):
                return "Missing field \(field) of type \(type)"
            case .typeMismatch(field: let field, forType: let fieldType, value: let value, expectedType: let expectedType):
                return "Type mismatch for field \(field) of type \(fieldType), \"\(value)\" is a \(type(of: value)) but is expected to be \(expectedType)"
            case .convertible(value: let value, expectedType: let expectedType):
                return "Could not convert \(value) to type \(expectedType)"
        }
    }
}
