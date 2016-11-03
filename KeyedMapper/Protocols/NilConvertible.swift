import Foundation

public protocol NilConvertible {
    /// This typealias allows us to enforce the returned value is of type Self, without requiring
    /// implementations to return a value using `self.init`
    associatedtype ConvertedType = Self

    /**
     `fromMap` returns the expected value based off the provided input, this allows you to attempt
     to cast the value to anything you'd like, and perform any manipulation on it (don't use this as a
     conversion mechanism, instead see Transform)

     - parameter value: Any value (probably from the data source's value for the given field) to create
     the expected object with

     - throws: Any error from your custom implementation, MapperError.convertible is recommended

     - returns: The successfully created value from the given input
     */
    static func fromMap(_ value: Any?) throws -> ConvertedType
}
