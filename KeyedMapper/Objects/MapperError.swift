import Foundation

public enum MapperError<Object: Mappable>: Error {
    case customError(field: Object.Key?, message: String)
    case invalidRawValueError(field: Object.Key, forType: Object.Type, value: Any, expectedType: Any.Type)
    case missingFieldError(field: Object.Key, forType: Object.Type)
    case typeMismatchError(field: Object.Key, forType: Object.Type, value: AnyObject, expectedType: Any.Type)
    case rootTypeMismatchError(forType: Object.Type, value: AnyObject, expectedType: Any.Type)
    
    public var failureReason: String {
        switch self {
            case .missingFieldError(field: let field, forType: let type):
                return "Missing field \(field.stringValue) of type \(type)"
            case .typeMismatchError(field: let field, forType: let type, value: let value, expectedType: let expectedType):
                return "Type mismatch for field \(field) of type \(type), \"\(value)\" is a \(type(of: value)) but is expected to be \(expectedType)"
            case .invalidRawValueError(field: let field, forType: let type, value: let value, expectedType: let expectedType):
                return "Invalid raw value for field \(field) of type \(type), \"\(value)\" is not a valid rawValue of \(expectedType)"
            case .rootTypeMismatchError(forType: let type, value: let value, expectedType: let expectedType):
                return "Type mismatch, root object \(value) of type \(type), expected to be of type \(expectedType)"
            default:
                //TODO: implement the rest
                return "failureReason not implemented"
        }
    }
}
