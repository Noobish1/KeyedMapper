import Foundation
import KeyedMapper

extension ConvertibleError: Equatable {}

public func == (lhs: ConvertibleError, rhs: ConvertibleError) -> Bool {
    return lhs.type == rhs.type
}
