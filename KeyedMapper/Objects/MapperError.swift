import Foundation

public enum MapperError: Error {
    case custom(field: String?, message: String)
    case invalidRawValue(rawValue: Any, rawValueType: Any.Type)
    case missingField(field: String, forType: Any.Type)
    case typeMismatch(field: String, forType: Any.Type, value: Any, expectedType: Any.Type)
    case rootTypeMismatch(forType: Any.Type, value: Any, expectedType: Any.Type)
    case convertible(value: Any, expectedType: Any.Type)

    public var failureReason: String {
        switch self {
            case .custom(_, message: let message):
                return message
            case .invalidRawValue(rawValue: let rawValue, rawValueType: let rawValueType):
                return "\"\(rawValue)\" is not a valid rawValue of \(rawValueType)"
            case .missingField(field: let field, forType: let type):
                return "Missing field \(field) of type \(type)"
            case .typeMismatch(field: let field, forType: let type, value: let value, expectedType: let expectedType):
                return "Type mismatch for field \(field) of type \(type), \"\(value)\" is a \(type(of: value)) but is expected to be \(expectedType)"
            case .rootTypeMismatch(forType: let type, value: let value, expectedType: let expectedType):
                return "Type mismatch, root object \(value) of type \(type), expected to be of type \(expectedType)"
            case .convertible(value: let value, expectedType: let expectedType):
                return "Could not convert \(value) to type \(expectedType)"
        }
    }
}
