import Foundation
import KeyedMapper

// swiftlint:disable cyclomatic_complexity
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
            case .invalidRawValue(rawValue: _, rawValueType: let lhsRawValueType):
                switch rhs {
                    case .invalidRawValue(rawValue: _, rawValueType: let rhsRawValueType):
                        return lhsRawValueType == rhsRawValueType
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
// swiftlint:enable cyclomatic_complexity
