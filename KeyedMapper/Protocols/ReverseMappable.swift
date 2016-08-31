import Foundation

public protocol ReverseMappable {
    associatedtype Key: JSONKey
    
    func toKeyedJSON() -> [Key : AnyObject?]
    func toJSON() -> NSDictionary
}

public extension ReverseMappable {
    public func toJSON() -> NSDictionary {
        return toKeyedJSON().mapKeys { $0.stringValue }.mapFilterValues { $0 } as NSDictionary
    }
}
