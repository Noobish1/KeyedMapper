import Foundation

internal final class JSON {
    private let dictionary: NSDictionary

    internal init(dictionary: NSDictionary) {
        self.dictionary = dictionary
    }

    // MARK: Retrieving JSON from a field
    internal func value<T>(fromField field: String, forObject object: Any.Type) throws -> T {
        guard let rawValue = safeValue(fromField: field, in: dictionary) else {
            throw MapperError.missingField(field: field, forType: object)
        }

        guard let value = rawValue as? T else {
            throw MapperError.typeMismatch(field: field, forType: object, value: rawValue, expectedType: T.self)
        }

        return value
    }

    private func safeValue(fromField field: String, in dictionary: NSDictionary) -> Any? {
        guard !field.isEmpty else {
            return dictionary
        }

        guard field.contains(".") else {
            return dictionary[field]
        }

        var object: Any? = dictionary
        var keys = field.split(separator: ".").map(String.init)

        while !keys.isEmpty, let currentObject = object {
            let key = keys.removeFirst()
            object = (currentObject as? NSDictionary)?[key]
        }

        return object
    }
}
