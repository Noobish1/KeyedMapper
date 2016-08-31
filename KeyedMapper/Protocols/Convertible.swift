import Foundation

public protocol Convertible {
    associatedtype ConvertedType = Self
    
    static func fromMap(_ value: AnyObject?) throws -> ConvertedType
}
