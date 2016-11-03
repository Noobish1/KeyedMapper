import Foundation
import KeyedMapper

extension MapperError: Equatable {
    public static func == (lhs: MapperError, rhs: MapperError) -> Bool {
        switch lhs {
            case .custom(field: let lhsField, message: let lhsMessage):
                switch rhs {
                    case .custom(field: let rhsField, message: let rhsMessage):
                        return lhsField == rhsField && lhsMessage == rhsMessage
                    default:
                        return false
                }
            case .invalidRawValue(field: let lhsField, forType: let lhsType, value: _, expectedType: let lhsExpectedType):
                switch rhs {
                    case .invalidRawValue(field: let rhsField, forType: let rhsType, value: _, expectedType: let rhsExpectedType):
                        return lhsField == rhsField && lhsType == rhsType && lhsExpectedType == rhsExpectedType
                    default:
                        return false
                }
            case .missingField(field: let lhsField, forType: let lhsType):
                switch rhs {
                    case .missingField(field: let rhsField, forType: let rhsType):
                        return lhsField == rhsField && lhsType == rhsType
                    default:
                        return false
                }
            case .typeMismatch(field: let lhsField, forType: let lhsType, value: _, expectedType: let lhsExpectedType):
                switch rhs {
                    case .typeMismatch(field: let rhsField, forType: let rhsType, value: _, expectedType: let rhsExpectedType):
                        return lhsField == rhsField && lhsType == rhsType && lhsExpectedType == rhsExpectedType
                    default:
                        return false
                }
            case .rootTypeMismatch(forType: let lhsType, value: _, expectedType: let lhsExpectedType):
                switch rhs {
                    case .rootTypeMismatch(forType: let rhsType, value: _, expectedType: let rhsExpectedType):
                        return lhsType == rhsType && lhsExpectedType == rhsExpectedType
                    default:
                        return false
                }
            case .convertible(value: _, expectedType: let lhsExpectedType):
                switch rhs {
                    case .convertible(value: _, expectedType: let rhsExpectedType):
                        return lhsExpectedType == rhsExpectedType
                    default:
                        return false
                }
        }
    }
}
