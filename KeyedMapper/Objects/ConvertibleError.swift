import Foundation

public struct ConvertibleError: Error {
    public let value: AnyObject?
    public let type: Any.Type
    
    public var failureReason: String {
        return "Could not convert \(value) to type \(type)"
    }
}
