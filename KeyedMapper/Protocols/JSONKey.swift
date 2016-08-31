import Foundation

public protocol JSONKey: RawRepresentable, Hashable {
    var stringValue: String { get }
}

extension JSONKey where Self.RawValue == String {
    public var stringValue: String {
        return self.rawValue
    }
}
