import Foundation

public struct ConvertibleError: Error {
    public let value: Any?
    public let type: Any.Type
    
    public init(value: Any?, type: Any.Type) {
        self.value = value
        self.type = type
    }
    
    public var failureReason: String {
        return "Could not convert \(value) to type \(type)"
    }
}
