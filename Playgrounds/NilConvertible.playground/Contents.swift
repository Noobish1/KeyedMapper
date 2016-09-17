import UIKit
import KeyedMapper

enum NilConvertibleEnum {
    case something
    case nothing
}

extension NilConvertibleEnum: NilConvertible {
    static func fromMap(_ value: Any?) throws -> NilConvertibleEnum {
        if let _ = value {
            return .something
        } else {
            return .nothing
        }
    }
}

let someEnumVariable = try NilConvertibleEnum.fromMap("")
let nothingEnumVariable = try NilConvertibleEnum.fromMap(nil)