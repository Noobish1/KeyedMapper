import UIKit
import CoreLocation
import KeyedMapper

// Implementation

extension NSTimeZone: Convertible {
    public static func fromMap(_ value: Any) throws -> NSTimeZone {
        guard let name = value as? String else {
            throw MapperError.convertibleError(value: value, expectedType: String.self)
        }
        
        guard let timeZone = self.init(name: name) else {
            throw MapperError.customError(field: nil, message: "Unsupported timezone \(name)")
        }
        
        return timeZone
    }
}

// Example usage

let badValue = 2

do {
    let _ = try NSTimeZone.fromMap(badValue)
} catch let error as MapperError {
    print(error.failureReason)
}

let goodValue = NSTimeZone(forSecondsFromGMT: 0).abbreviation!
let timezone = try NSTimeZone.fromMap(goodValue)

print(timezone)