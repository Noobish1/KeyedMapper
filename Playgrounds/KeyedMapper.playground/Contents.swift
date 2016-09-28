import UIKit
import KeyedMapper

// Convertible

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

// NilConvertible

enum NilConvertibleEnum {
    case something
    case nothing
}

extension NilConvertibleEnum: NilConvertible {
    static func fromMap(_ value: Any?) throws -> NilConvertibleEnum {
        if let _ = value {
            return .something
        } else {
            return .nothing
        }
    }
}

// Mappable

struct SubObject {
    let property: String
}

extension SubObject: Mappable {
    enum Key: String, JSONKey {
        case property
    }

    init(map: KeyedMapper<SubObject>) throws {
        self.property = try map.from(.property)
    }
}

struct Object {
    let property: String
    let optionalProperty: String?
    let convertibleProperty: NSTimeZone
    let optionalConvertibleProperty: NSTimeZone?
    let nilConvertibleProperty: NilConvertibleEnum
    let arrayProperty: [String]
    let optionalArrayProperty: [String]?
}

extension Object: Mappable {
    enum Key: String, JSONKey {
        case property
        case optionalProperty
        case convertibleProperty
        case optionalConvertibleProperty
        case nilConvertibleProperty
        case arrayProperty
        case optionalArrayProperty
    }
    
    init(map: KeyedMapper<Object>) throws {
        self.property = try map.from(.property)
        self.optionalProperty = map.optionalFrom(.optionalProperty)
        self.convertibleProperty = try map.from(.convertibleProperty)
        self.optionalConvertibleProperty = map.optionalFrom(.optionalConvertibleProperty)
        self.nilConvertibleProperty = try map.from(.nilConvertibleProperty)
        self.arrayProperty = try map.from(.arrayProperty)
        self.optionalArrayProperty = map.optionalFrom(.optionalArrayProperty)
    }
}

let JSON: [AnyHashable : Any] = ["property" : "propertyValue",
                                 "convertibleProperty" : NSTimeZone(forSecondsFromGMT: 0).abbreviation,
                                 "arrayProperty": ["arrayPropertyValue1", "arrayPropertyValue2"]]

let object = try Object.from(dictionary: JSON)

print(object)

// ReverseMappable

extension Object: ReverseMappable {
    func toKeyedJSON() -> [Object.Key : Any?] {
        return [.property : property,
                .optionalProperty : optionalProperty,
                .convertibleProperty : convertibleProperty,
                .optionalConvertibleProperty : optionalConvertibleProperty,
                .nilConvertibleProperty : nilConvertibleProperty,
                .arrayProperty : arrayProperty,
                .optionalArrayProperty : optionalArrayProperty
        ]
    }
}

let outJSON = object.toJSON()

print(outJSON)
