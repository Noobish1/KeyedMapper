import Foundation

public struct ConvertibleError: Error {
    public let value: AnyObject?
    public let type: Any.Type
}
