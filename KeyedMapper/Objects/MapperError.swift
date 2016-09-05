import Foundation

public enum MapperError<Object: Mappable>: Error {
    case customError(field: Object.Key?, message: String)
    case invalidRawValueError(field: Object.Key, forType: Object.Type, value: Any, expectedType: Any.Type)
    case missingFieldError(field: Object.Key, forType: Object.Type)
    case typeMismatchError(field: Object.Key, forType: Object.Type, value: AnyObject, expectedType: Any.Type)
    case rootTypeMismatchError(forType: Object.Type, value: AnyObject, expectedType: Any.Type)
    
    public var failureReason: String {
        switch self {
            case .customError(_, message: let message):
                return message
            case .invalidRawValueError(field: let field, forType: let type, value: let value, expectedType: let expectedType):
                return "Invalid raw value for field \(field) of type \(type), \"\(value)\" is not a valid rawValue of \(expectedType)"
            case .missingFieldError(field: let field, forType: let type):
                return "Missing field \(field.stringValue) of type \(type)"
            case .typeMismatchError(field: let field, forType: let type, value: let value, expectedType: let expectedType):
                return "Type mismatch for field \(field) of type \(type), \"\(value)\" is a \(type(of: value)) but is expected to be \(expectedType)"
            case .rootTypeMismatchError(forType: let type, value: let value, expectedType: let expectedType):
                return "Type mismatch, root object \(value) of type \(type), expected to be of type \(expectedType)"
        }
    }
}

extension MapperError: Equatable {}

public func == <T>(lhs: MapperError<T>, rhs: MapperError<T>) -> Bool where T: Mappable {
    switch lhs {
        case .customError(field: let lhsField, message: let lhsMessage):
            switch rhs {
                case .customError(field: let rhsField, message: let rhsMessage):
                    return lhsField == rhsField && lhsMessage == rhsMessage
                default:
                    return false
            }
        case .invalidRawValueError(field: let lhsField, forType: let lhsType, value: _, expectedType: let lhsExpectedType):
            switch rhs {
                case .invalidRawValueError(field: let rhsField, forType: let rhsType, value: _, expectedType: let rhsExpectedType):
                    return lhsField == rhsField && lhsType == rhsType && lhsExpectedType == rhsExpectedType
                default:
                    return false
        }
        case .missingFieldError(field: let lhsField, forType: let lhsType):
            switch rhs {
                case .missingFieldError(field: let rhsField, forType: let rhsType):
                    return lhsField == rhsField && lhsType == rhsType
                default:
                    return false
        }
        case .typeMismatchError(field: let lhsField, forType: let lhsType, value: _, expectedType: let lhsExpectedType):
            switch rhs {
                case .typeMismatchError(field: let rhsField, forType: let rhsType, value: _, expectedType: let rhsExpectedType):
                    return lhsField == rhsField && lhsType == rhsType && lhsExpectedType == rhsExpectedType
                default:
                    return false
        }
        case .rootTypeMismatchError(forType: let lhsType, value: _, expectedType: let lhsExpectedType):
            switch rhs {
                case .rootTypeMismatchError(forType: let rhsType, value: _, expectedType: let rhsExpectedType):
                    return lhsType == rhsType && lhsExpectedType == rhsExpectedType
                default:
                    return false
        }
    }
}
