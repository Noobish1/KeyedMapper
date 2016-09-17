import Foundation

public enum MapperError: Error {
    case customError(field: String?, message: String)
    case invalidRawValueError(field: String, forType: Any.Type, value: Any, expectedType: Any.Type)
    case missingFieldError(field: String, forType: Any.Type)
    case typeMismatchError(field: String, forType: Any.Type, value: Any, expectedType: Any.Type)
    case rootTypeMismatchError(forType: Any.Type, value: Any, expectedType: Any.Type)
    case convertibleError(value: Any, expectedType: Any.Type)

    public var failureReason: String {
        switch self {
            case .customError(_, message: let message):
                return message
            case .invalidRawValueError(field: let field, forType: let type, value: let value, expectedType: let expectedType):
                return "Invalid raw value for field \(field) of type \(type), \"\(value)\" is not a valid rawValue of \(expectedType)"
            case .missingFieldError(field: let field, forType: let type):
                return "Missing field \(field) of type \(type)"
            case .typeMismatchError(field: let field, forType: let type, value: let value, expectedType: let expectedType):
                return "Type mismatch for field \(field) of type \(type), \"\(value)\" is a \(type(of: value)) but is expected to be \(expectedType)"
            case .rootTypeMismatchError(forType: let type, value: let value, expectedType: let expectedType):
                return "Type mismatch, root object \(value) of type \(type), expected to be of type \(expectedType)"
            case .convertibleError(value: let value, expectedType: let expectedType):
                return "Could not convert \(value) to type \(expectedType)"
        }
    }
}
