import Foundation

public protocol ReverseMappable {
    associatedtype Key: JSONKey

    func toKeyedJSON() -> [Key : Any?]
    func toJSON() -> [AnyHashable : Any]
}

public extension ReverseMappable {
    public func toJSON() -> [AnyHashable : Any] {
        return toKeyedJSON().mapKeys { $0.stringValue }.mapFilterValues { $0 } as [AnyHashable : Any]
    }
}
