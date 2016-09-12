import Foundation
import KeyedMapper

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
